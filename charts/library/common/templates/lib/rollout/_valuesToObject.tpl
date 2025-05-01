{{/*
Convert Rollout values to an object
*/}}
{{- define "bjw-s.common.lib.rollout.valuesToObject" -}}
  {{- $rootContext := .rootContext -}}
  {{- $identifier := .id -}}
  {{- $objectValues := .values -}}

  {{- $strategy := default "Recreate" $objectValues.strategy -}}
  {{- $_ := set $objectValues "strategy" $strategy -}}

  {{- /* Return the Rollout object */ -}}
  {{- $objectValues | toYaml -}}
{{- end -}}
