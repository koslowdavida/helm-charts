{{/*
This template serves as a blueprint for Rollout objects that are created
using the common library.
*/}}
{{- define "bjw-s.common.class.rollout" -}}
  {{- $rootContext := .rootContext -}}
  {{- $rolloutObject := .object -}}

  {{- $labels := merge
    (dict "app.kubernetes.io/component" $rolloutObject.identifier)
    ($rolloutObject.labels | default dict)
    (include "bjw-s.common.lib.metadata.allLabels" $rootContext | fromYaml)
  -}}
  {{- $annotations := merge
    ($rolloutObject.annotations | default dict)
    (include "bjw-s.common.lib.metadata.globalAnnotations" $rootContext | fromYaml)
  -}}
---
apiVersion: argoproj.io/v1alpha1
kind: Rollout
metadata:
  name: {{ $rolloutObject.name }}
  {{- with $labels }}
  labels:
    {{- range $key, $value := . }}
    {{- printf "%s: %s" $key (tpl $value $rootContext | toYaml ) | nindent 4 }}
    {{- end }}
  {{- end }}
  {{- with $annotations }}
  annotations:
    {{- range $key, $value := . }}
    {{- printf "%s: %s" $key (tpl $value $rootContext | toYaml ) | nindent 4 }}
    {{- end }}
  {{- end }}
  namespace: {{ $rootContext.Release.Namespace }}
spec:
  revisionHistoryLimit: {{ include "bjw-s.common.lib.defaultKeepNonNullValue" (dict "value" $rolloutObject.revisionHistoryLimit "default" 3) }}
  {{- if hasKey $rolloutObject "replicas" }}
    {{- if not (eq $rolloutObject.replicas nil) }}
  replicas: {{ $rolloutObject.replicas }}
    {{- end }}
  {{- else }}
  replicas: 1
  {{- end }}
  strategy:
    {{- if $rolloutObject.strategy.blueGreen }}
    blueGreen:
      {{- with $rolloutObject.strategy.blueGreen.activeService }}
      activeService: {{ . }}
      {{- end }}
      {{- with $rolloutObject.strategy.blueGreen.previewService }}
      previewService: {{ . }}
      {{- end }}
      {{- with $rolloutObject.strategy.blueGreen.preferExactMatch }}
      preferExactMatch: {{ . }}
      {{- end }}
      {{- with $rolloutObject.strategy.blueGreen.scaleDownDelaySeconds }}
      scaleDownDelaySeconds: {{ . }}
      {{- end }}
      {{- with $rolloutObject.strategy.blueGreen.scaleDownDelayRevisionLimit }}
      scaleDownDelayRevisionLimit: {{ . }}
      {{- end }}
      {{- with $rolloutObject.strategy.blueGreen.prePromotionAnalysis }}
      prePromotionAnalysis:
        {{- with .args }}
        args: {{ . | toYaml | nindent 10 }}
        {{- end }}
        {{- with .template }}
        template:
          {{- with .metadata }}
          metadata:
            {{- with .labels }}
            labels: {{ . | toYaml | nindent 12 }}
            {{- end }}
            {{- with .annotations }}
            annotations: {{ . | toYaml | nindent 12 }}
            {{- end }}
          {{- end }}
          {{- with .spec }}
          spec: {{ . | toYaml | nindent 10 }}
          {{- end }}
        {{- end }}
        {{- with .measurement }}
        measurement:
          {{- with .type }}
          type: {{ . }}
          {{- end }}
          {{- with .value }}
          value: {{ . }}
          {{- end }}
          {{- with .intervalSeconds }}
          intervalSeconds: {{ . }}
          {{- end }}
          {{- with .count }}
          count: {{ . }}
          {{- end }}
          {{- with .successCondition }}
          successCondition: {{ . }}
          {{- end }}
          {{- with .failureCondition }}
          failureCondition: {{ . }}
          {{- end }}
        {{- end }}
      {{- end }}
      {{- with $rolloutObject.strategy.blueGreen.postPromotionAnalysis }}
      postPromotionAnalysis:
        {{- with .args }}
        args: {{ . | toYaml | nindent 10 }}
        {{- end }}
        {{- with .template }}
        template:
          {{- with .metadata }}
          metadata:
            {{- with .labels }}
            labels: {{ . | toYaml | nindent 12 }}
            {{- end }}
            {{- with .annotations }}
            annotations: {{ . | toYaml | nindent 12 }}
            {{- end }}
          {{- end }}
          {{- with .spec }}
          spec: {{ . | toYaml | nindent 10 }}
          {{- end }}
        {{- end }}
        {{- with .measurement }}
        measurement:
          {{- with .type }}
          type: {{ . }}
          {{- end }}
          {{- with .value }}
          value: {{ . }}
          {{- end }}
          {{- with .intervalSeconds }}
          intervalSeconds: {{ . }}
          {{- end }}
          {{- with .count }}
          count: {{ . }}
          {{- end }}
          {{- with .successCondition }}
          successCondition: {{ . }}
          {{- end }}
          {{- with .failureCondition }}
          failureCondition: {{ . }}
          {{- end }}
        {{- end }}
      {{- end }}
    {{- end }}

    {{- if $rolloutObject.strategy.canary }}
    canary:
      {{- with $rolloutObject.strategy.canary.steps }}
      steps:
        {{- range $step := . }}
        - {{- if hasKey $step "setWeight" }}
            setWeight: {{ $step.setWeight }}
          {{- end }}
          {{- if hasKey $step "pause" }}
            pause:
              {{- with $step.pause.duration }}
              duration: {{ . }}
              {{- end }}
          {{- end }}
          {{- if hasKey $step "setCanaryScale" }}
            setCanaryScale:
              {{- with $step.setCanaryScale.weight }}
              weight: {{ . }}
              {{- end }}
              {{- with $step.setCanaryScale.replicas }}
              replicas: {{ . }}
              {{- end }}
              {{- with $step.setCanaryScale.matchTrafficWeight }}
              matchTrafficWeight: {{ . }}
              {{- end }}
          {{- end }}
        {{- end }}
      {{- end }}
      {{- with $rolloutObject.strategy.canary.canaryService }}
      canaryService: {{ . }}
      {{- end }}
      {{- with $rolloutObject.strategy.canary.stableService }}
      stableService: {{ . }}
      {{- end }}
      {{- with $rolloutObject.strategy.canary.trafficRouting }}
      trafficRouting:
        {{- with .istio }}
        istio:
          {{- with .virtualService }}
          virtualService:
            {{- with .name }}
            name: {{ . }}
            {{- end }}
            {{- with .namespace }}
            namespace: {{ . }}
            {{- end }}
          {{- end }}
          {{- with .destination }}
          destination:
            {{- with .name }}
            name: {{ . }}
            {{- end }}
            {{- with .namespace }}
            namespace: {{ . }}
            {{- end }}
          {{- end }}
        {{- end }}
        {{- with .nginx }}
        nginx:
          {{- with .annotations }}
          annotations:
            {{- range $key, $value := . }}
            {{- printf "%s: %s" $key $value | nindent 12 }}
            {{- end }}
          {{- end }}
        {{- end }}
      {{- end }}
      {{- with $rolloutObject.strategy.canary.analysis }}
      analysis:
        {{- with .args }}
        args: {{ . | toYaml | nindent 10 }}
        {{- end }}
        {{- with .template }}
        template:
          {{- with .metadata }}
          metadata:
            {{- with .labels }}
            labels: {{ . | toYaml | nindent 12 }}
            {{- end }}
            {{- with .annotations }}
            annotations: {{ . | toYaml | nindent 12 }}
            {{- end }}
          {{- end }}
          {{- with .spec }}
          spec: {{ . | toYaml | nindent 10 }}
          {{- end }}
        {{- end }}
        {{- with .measurement }}
        measurement:
          {{- with .type }}
          type: {{ . }}
          {{- end }}
          {{- with .value }}
          value: {{ . }}
          {{- end }}
          {{- with .intervalSeconds }}
          intervalSeconds: {{ . }}
          {{- end }}
          {{- with .count }}
          count: {{ . }}
          {{- end }}
          {{- with .successCondition }}
          successCondition: {{ . }}
          {{- end }}
          {{- with .failureCondition }}
          failureCondition: {{ . }}
          {{- end }}
        {{- end }}
      {{- end }}
    {{- end }}

    {{- if $rolloutObject.strategy.rollingUpdate }}
    rollingUpdate:
      {{- with $rolloutObject.strategy.rollingUpdate.maxSurge }}
      maxSurge: {{ . }}
      {{- end }}
      {{- with $rolloutObject.strategy.rollingUpdate.maxUnavailable }}
      maxUnavailable: {{ . }}
      {{- end }}
    {{- end }}

  selector:
    matchLabels:
      app.kubernetes.io/component: {{ $rolloutObject.identifier }}
      {{- include "bjw-s.common.lib.metadata.selectorLabels" $rootContext | nindent 6 }}
  template:
    metadata:
      {{- with (include "bjw-s.common.lib.pod.metadata.annotations" (dict "rootContext" $rootContext "controllerObject" $rolloutObject)) }}
      annotations: {{ . | nindent 8 }}
      {{- end -}}
      {{- with (include "bjw-s.common.lib.pod.metadata.labels" (dict "rootContext" $rootContext "controllerObject" $rolloutObject)) }}
      labels: {{ . | nindent 8 }}
      {{- end }}
    spec: {{ include "bjw-s.common.lib.pod.spec" (dict "rootContext" $rootContext "controllerObject" $rolloutObject) | nindent 6 }}
{{- end -}}
