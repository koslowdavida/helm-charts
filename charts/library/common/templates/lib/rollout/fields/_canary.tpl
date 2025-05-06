{{/*
Template for canary strategy fields. Applies tpl to each string value.
*/}}
{{- define "bjw-s.common.lib.rollout.fields.canary" -}}
  {{- $rootContext := .rootContext -}}
  {{- $values := .values -}}
canary:
  {{- with $values.analysis }}
  analysis: {{ toYaml . | nindent 4 }}
  {{- end }}
  {{- with $values.antiAffinity }}
  antiAffinity: {{ toYaml . | nindent 4 }}
  {{- end }}
  {{- with $values.canaryService }}
  canaryService: {{ tpl . $rootContext | quote }}
  {{- end }}
  {{- with $values.stableService }}
  stableService: {{ tpl . $rootContext | quote }}
  {{- end }}
  {{- with $values.maxSurge }}
  maxSurge: {{ . }}
  {{- end }}
  {{- with $values.maxUnavailable }}
  maxUnavailable: {{ . }}
  {{- end }}
  {{- with $values.trafficRouting }}
  trafficRouting: {{ toYaml . | nindent 4 }}
  {{- end }}
{{- end -}}
