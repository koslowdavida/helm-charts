{{/*
Template for blueGreen strategy fields. Applies tpl to each string value.
*/}}
{{- define "bjw-s.common.lib.rollout.fields.blueGreen" -}}
  {{- $rootContext := .rootContext -}}
  {{- $values := .values -}}
blueGreen:
  activeService: {{ tpl $values.activeService $rootContext | quote }}
  {{- with $values.previewService }}
  previewService: {{ tpl . $rootContext | quote }}
  {{- end }}
  {{- with $values.autoPromotionEnabled }}
  autoPromotionEnabled: {{ . }}
  {{- end }}
  {{- with $values.autoPromotionSeconds }}
  autoPromotionSeconds: {{ . }}
  {{- end }}
  {{- with $values.antiAffinity }}
  antiAffinity: {{ toYaml . | nindent 4 }}
  {{- end }}
  {{- with $values.prePromotionAnalysis }}
  prePromotionAnalysis: {{ toYaml . | nindent 4 }}
  {{- end }}
  {{- with $values.postPromotionAnalysis }}
  postPromotionAnalysis: {{ toYaml . | nindent 4 }}
  {{- end }}
  {{- with $values.previewReplicaCount }}
  previewReplicaCount: {{ . }}
  {{- end }}
  {{- with $values.scaleDownDelaySeconds }}
  scaleDownDelaySeconds: {{ . }}
  {{- end }}
  {{- with $values.scaleDownDelayRevisionLimit }}
  scaleDownDelayRevisionLimit: {{ . }}
  {{- end }}
  {{- with $values.preferExactMatch }}
  preferExactMatch: {{ . }}
  {{- end }}
{{- end -}}
