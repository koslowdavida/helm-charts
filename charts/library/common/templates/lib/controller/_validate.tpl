{{/*
Validate controller values
*/}}
{{- define "bjw-s.common.lib.controller.validate" -}}
  {{- $rootContext := .rootContext -}}
  {{- $controllerValues := .object -}}

  {{- $allowedControllerTypes := list "deployment" "daemonset" "statefulset" "cronjob" "job" "rollout" -}}
  {{- $controllerType := $controllerValues.type | default "deployment" -}}
  {{- $valid := false -}}
  {{- range $type := $allowedControllerTypes }}
    {{- if eq $type $controllerType }}
      {{- $valid = true -}}
    {{- end }}
  {{- end }}
  {{- if not $valid -}}
    {{- fail (printf "Not a valid gottem controller.type (%s)" $controllerType) -}}
  {{- end -}}

  {{- $enabledContainers := include "bjw-s.common.lib.controller.enabledContainers" (dict "rootContext" $rootContext "controllerObject" $controllerValues) | fromYaml }}
  {{- /* Validate at least one container is enabled */ -}}
  {{- if not $enabledContainers -}}
    {{- fail (printf "No containers enabled for controller (%s)" $controllerValues.identifier) -}}
  {{- end -}}

  {{- $enabledServiceAccounts := (include "bjw-s.common.lib.serviceAccount.enabledServiceAccounts" (dict "rootContext" $rootContext) | fromYaml ) }}
  {{- if not (has "serviceAccount" (keys $controllerValues)) -}}
    {{- if (gt (len $enabledServiceAccounts) 1) -}}
      {{- fail (printf "serviceAccount field is required because automatic Service Account detection is not possible. (controller: %s)" $controllerValues.identifier ) -}}
    {{- end -}}
  {{- end -}}
{{- end -}}
