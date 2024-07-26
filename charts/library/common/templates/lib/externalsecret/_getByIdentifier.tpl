{{/*
Return an externalsecret Object by its Identifier.
*/}}
{{- define "bjw-s.common.lib.externalsecret.getByIdentifier" -}}
  {{- $rootContext := .rootContext -}}
  {{- $identifier := .id -}}

  {{- $externalsecretValues := dig $identifier nil $rootContext.Values.externalsecrets -}}
  {{- if not (empty $externalsecretValues) -}}
    {{- include "bjw-s.common.lib.externalsecret.valuesToObject" (dict "rootContext" $rootContext "id" $identifier "values" $externalsecretValues) -}}
  {{- end -}}
{{- end -}}
