{{/*
Validate Rollout values
*/}}
{{- define "bjw-s.common.lib.rollout.validate" -}}
  {{- $rootContext := .rootContext -}}
  {{- $rolloutValues := .object -}}

  {{- if and (ne $rolloutValues.strategy "Recreate") (ne $rolloutValues.strategy "RollingUpdate") -}}
    {{- fail (printf "Not a valid strategy type for Rollout. (controller: %s, strategy: %s)" $rolloutValues.identifier $rolloutValues.strategy) }}
  {{- end -}}
{{- end -}}
