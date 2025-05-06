{{/*
Convert Rollout values to an object
*/}}
{{- define "bjw-s.common.lib.rollout.valuesToObject" -}}
  {{- $rootContext := .rootContext -}}
  {{- $identifier := .id -}}
  {{- $objectValues := .values -}}

  {{- $strategy := $objectValues.strategy -}}

  {{- /* Process any templates in the tag */ -}}
  {{- $strategy = tpl $strategy $rootContext -}}

  {{- $_ := set $objectValues "strategy" $strategy -}}

  {{- /* Return the Rollout object */ -}}
  {{- $objectValues | toYaml -}}
{{- end -}}
