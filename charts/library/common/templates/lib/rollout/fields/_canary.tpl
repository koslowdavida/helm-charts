{{/*
Template for canary strategy fields. Applies tpl to each string value.
*/}}
{{- define "bjw-s.common.lib.rollout.fields.canary" -}}
  {{- $rootContext := .rootContext -}}
  {{- $values := .values -}}
canary:
  steps: {{ tpl $values.steps $rootContext }}
  stableService: {{ tpl $values.stableService $rootContext | quote }}
  canaryService: {{ tpl $values.canaryService $rootContext | quote }}
{{- end -}}
