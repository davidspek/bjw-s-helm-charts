{{/*
Validate component values
*/}}
{{- define "bjw-s.common.lib.component.validate" -}}
  {{- $rootContext := .rootContext -}}
  {{- $componentValues := .object -}}

  {{- $allowedComponentTypes := list "deployment" "daemonset" "statefulset" "cronjob" "job" -}}
  {{- if not (has $componentValues.type $allowedComponentTypes) -}}
    {{- fail (printf "Not a valid component.type (%s)" $componentValues.type) -}}
  {{- end -}}

  {{- $enabledContainers := include "bjw-s.common.lib.component.enabledContainers" (dict "rootContext" $rootContext "componentObject" $componentValues) | fromYaml }}
  {{- /* Validate at least one container is enabled */ -}}
  {{- if not $enabledContainers -}}
    {{- fail (printf "No containers enabled for component (%s)" $componentValues.identifier) -}}
  {{- end -}}
{{- end -}}
