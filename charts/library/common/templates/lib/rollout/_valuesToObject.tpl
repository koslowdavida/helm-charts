{{/*
Convert Rollout values to an object
*/}}
{{- define "bjw-s.common.lib.rollout.valuesToObject" -}}
  {{- $rootContext := .rootContext -}}
  {{- $identifier := .id -}}
  {{- $objectValues := .values -}}
  {{- $strategy := $objectValues.strategy -}}

  {{- $strategyObject := dict -}}
  {{- /* Render the strategy object using the strategy lib */ -}}
  {{- if $strategy.blueGreen }}
    {{- $strategyObject = (include "bjw-s.common.lib.rollout.fields.blueGreen" (dict "rootContext" $rootContext "values" $strategy.blueGreen) | fromYaml) -}}
  {{- else if $strategy.canary }}
    {{- $strategyObject = (include "bjw-s.common.lib.rollout.fields.canary" (dict "rootContext" $rootContext "values" $strategy.canary) | fromYaml) -}}
  {{- else }}
    {{- fail "Unknown or missing strategy type" }}
  {{- end }}

  {{- $_ := set $objectValues "strategy" $strategyObject -}}

  {{- $objectValues | toYaml -}}
{{- end -}}
