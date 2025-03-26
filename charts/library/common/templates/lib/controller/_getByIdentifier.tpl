{{/*
Return a component by its identifier.
*/}}
{{- define "bjw-s.common.lib.component.getByIdentifier" -}}
  {{- $rootContext := .rootContext -}}
  {{- $identifier := .id -}}

  {{- $enabledComponents := include "bjw-s.common.lib.component.enabledComponents" (dict "rootContext" $rootContext) | fromYaml -}}
  {{- $componentValues := get $enabledComponents $identifier -}}

  {{- if not (empty $componentValues) -}}
    {{- include "bjw-s.common.lib.component.valuesToObject" (dict "rootContext" $rootContext "id" $identifier "values" $componentValues) -}}
  {{- end -}}
{{- end -}}
