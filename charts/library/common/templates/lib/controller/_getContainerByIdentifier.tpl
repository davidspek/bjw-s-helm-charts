{{/*
Return a container by its identifier.
*/}}
{{- define "bjw-s.common.lib.component.getContainerByIdentifier" -}}
  {{- $rootContext := .rootContext -}}
  {{- $componentObject := .componentObject -}}
  {{- $identifier := .id -}}

  {{- $enabledContainers := include "bjw-s.common.lib.component.enabledContainers" (dict "rootContext" $rootContext "componentObject" $componentObject) | fromYaml -}}
  {{- $containerValues := get $enabledContainers $identifier -}}

  {{- if not (empty $containerValues) -}}
    {{- include "bjw-s.common.lib.container.valuesToObject" (dict "rootContext" $rootContext "componentObject" $componentObject "containerType" "default" "id" $identifier "values" $containerValues) -}}
  {{- end -}}
{{- end -}}
