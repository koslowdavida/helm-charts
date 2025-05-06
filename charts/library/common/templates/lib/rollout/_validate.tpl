{{/*
Validate Rollout values
*/}}
{{- define "bjw-s.common.lib.rollout.validate" -}}
  {{- $rootContext := .rootContext -}}
  {{- $rolloutValues := .object -}}

  {{- /* Validate strategy exists */ -}}
  {{- if not $rolloutValues.strategy -}}
    {{- fail (printf "Rollout strategy is required for controller: %s" $rolloutValues.identifier) }}
  {{- end -}}

  {{- /* Validate strategy type */ -}}
  {{- $strategy := $rolloutValues.strategy -}}
  {{- $strategyTypeCount := 0 -}}
  {{- if $strategy.blueGreen }}
    {{- $strategyTypeCount = add $strategyTypeCount 1 -}}
  {{- end -}}
  {{- if $strategy.canary }}
    {{- $strategyTypeCount = add $strategyTypeCount 1 -}}
  {{- end -}}

  {{- /* Ensure exactly one strategy type is specified */ -}}
  {{- if not (eq $strategyTypeCount 1) -}}
    {{- fail (printf "Exactly one strategy type must be specified for Rollout (controller: %s). Found: %d" $rolloutValues.identifier $strategyTypeCount) }}
  {{- end -}}

  {{- /* Validate strategy-specific fields */ -}}
  {{- if $strategy.blueGreen -}}
    {{- if not $strategy.blueGreen.activeService -}}
      {{- fail (printf "blueGreen.activeService is required for Rollout (controller: %s)" $rolloutValues.identifier) }}
    {{- end -}}
    {{- if not $strategy.blueGreen.previewService -}}
      {{- fail (printf "blueGreen.previewService is required for Rollout (controller: %s)" $rolloutValues.identifier) }}
    {{- end -}}
  {{- end -}}

  {{- if $strategy.canary -}}
    {{- if not $strategy.canary.steps -}}
      {{- fail (printf "canary.steps is required for Rollout (controller: %s)" $rolloutValues.identifier) }}
    {{- end -}}
    {{- if not $strategy.canary.stableService -}}
      {{- fail (printf "canary.stableService is required for Rollout (controller: %s)" $rolloutValues.identifier) }}
    {{- end -}}
    {{- if not $strategy.canary.canaryService -}}
      {{- fail (printf "canary.canaryService is required for Rollout (controller: %s)" $rolloutValues.identifier) }}
    {{- end -}}
  {{- end -}}
{{- end -}}
