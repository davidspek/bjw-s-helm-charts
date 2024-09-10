{{/*
Return the primary service object for a component
*/}}
{{- define "bjw-s.common.lib.service.primaryForComponent" -}}
  {{- $rootContext := .rootContext -}}
  {{- $componentIdentifier := .componentIdentifier -}}

  {{- $identifier := "" -}}
  {{- $result := dict -}}

  {{- /* Loop over all enabled services */ -}}
  {{- $enabledServices := (include "bjw-s.common.lib.service.enabledServices" (dict "rootContext" $rootContext) | fromYaml ) }}
  {{- if $enabledServices -}}
    {{- /* We are only interested in services for the specified component */ -}}
    {{- $enabledServicesForComponent := dict -}}
    {{- range $name, $service := $enabledServices -}}
      {{- if eq $service.component $componentIdentifier -}}
        {{- $_ := set $enabledServicesForComponent $name $service -}}
      {{- end -}}
    {{- end -}}

    {{- range $name, $service := $enabledServicesForComponent -}}
      {{- /* Determine the Service that has been marked as primary */ -}}
      {{- if $service.primary -}}
        {{- $identifier = $name -}}
        {{- $result = $service -}}
      {{- end -}}

      {{- /* Return the first Service if none has been explicitly marked as primary */ -}}
      {{- if not $result -}}
        {{- $firstServiceKey := keys $enabledServicesForComponent | first -}}
        {{- $result = get $enabledServicesForComponent $firstServiceKey -}}
        {{- $identifier = $result.identifier -}}
      {{- end -}}
    {{- end -}}

    {{- include "bjw-s.common.lib.service.valuesToObject" (dict "rootContext" $rootContext "id" $identifier "values" $result) -}}
  {{- end -}}
{{- end -}}
