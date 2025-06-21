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
  strategy: {{ toYaml $rolloutObject.strategy | nindent 4 }}
  selector:
    matchLabels:
      app.kubernetes.io/controller: {{ $rolloutObject.identifier }}
      {{- include "bjw-s.common.lib.metadata.selectorLabels" $rootContext | nindent 6 }}
  template:
    metadata:
      {{- with (include "bjw-s.common.lib.pod.metadata.annotations" (dict "rootContext" $rootContext "controllerObject" $rolloutObject)) }}
      annotations: {{ tpl . $rootContext | nindent 8 }}
      {{- end -}}
      {{- with (include "bjw-s.common.lib.pod.metadata.labels" (dict "rootContext" $rootContext "controllerObject" $rolloutObject)) }}
      labels: {{ . | nindent 8 }}
      {{- end }}
    spec: {{ include "bjw-s.common.lib.pod.spec" (dict "rootContext" $rootContext "controllerObject" $rolloutObject) | nindent 6 }}
{{- end -}}
