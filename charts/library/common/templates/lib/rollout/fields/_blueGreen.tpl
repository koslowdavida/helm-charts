{{/*
Template for blueGreen strategy fields. Applies tpl to each string value.
*/}}
{{- define "bjw-s.common.lib.rollout.fields.blueGreen" -}}
  {{- $rootContext := .rootContext -}}
  {{- $values := .values -}}
blueGreen:
  activeService: {{ tpl $values.activeService $rootContext | quote }}
  previewService: {{ tpl $values.previewService $rootContext | quote }}
  autoPromotionEnabled: {{ $values.autoPromotionEnabled }}
  autoPromotionSeconds: {{ $values.autoPromotionSeconds }}
  previewReplicaCount: {{ $values.previewReplicaCount }}
{{- end -}}
