{{/*
Template for rollingUpdate strategy fields. Applies tpl to each string value.
*/}}
{{- define "bjw-s.common.lib.rollout.fields.rollingUpdate" -}}
  {{- $rootContext := .rootContext -}}
  {{- $values := .values -}}
rollingUpdate:
  maxSurge: {{ tpl $values.maxSurge $rootContext | quote }}
  maxUnavailable: {{ tpl $values.maxUnavailable $rootContext | quote }}
{{- end -}}
