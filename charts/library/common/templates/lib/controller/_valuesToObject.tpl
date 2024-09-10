{{/*
Convert component values to an object
*/}}
{{- define "bjw-s.common.lib.component.valuesToObject" -}}
  {{- $rootContext := .rootContext -}}
  {{- $identifier := .id -}}
  {{- $objectValues := .values -}}

  {{- /* Default the component type to Deployment */ -}}
  {{- if empty (dig "type" nil $objectValues) -}}
    {{- $_ := set $objectValues "type" "deployment" -}}
  {{- end -}}

  {{- /* Determine and inject the component name */ -}}
  {{- $objectName := (include "bjw-s.common.lib.chart.names.fullname" $rootContext) -}}

  {{- if $objectValues.nameOverride -}}
    {{- $override := tpl $objectValues.nameOverride $rootContext -}}
    {{- if not (eq $objectName $override) -}}
      {{- $objectName = printf "%s-%s" $objectName $override -}}
    {{- end -}}
  {{- else -}}
    {{- $enabledComponents := (include "bjw-s.common.lib.component.enabledComponents" (dict "rootContext" $rootContext) | fromYaml ) }}
    {{- if gt (len $enabledComponents) 1 -}}
      {{- if not (eq $objectName $identifier) -}}
        {{- $objectName = printf "%s-%s" $objectName $identifier -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}
  {{- $_ := set $objectValues "name" $objectName -}}
  {{- $_ := set $objectValues "identifier" $identifier -}}

  {{- /* Return the component object */ -}}
  {{- $objectValues | toYaml -}}
{{- end -}}
