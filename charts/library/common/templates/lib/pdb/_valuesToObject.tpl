{{/*
Convert PodDisruptionBudget values to an object
*/}}
{{- define "bjw-s.common.lib.pdb.valuesToObject" -}}
  {{- $rootContext := .rootContext -}}
  {{- $identifier := .id -}}
  {{- $objectValues := .values -}}

  {{- /* Determine and inject the PodDisruptionBudget name */ -}}
  {{- $objectName := (include "bjw-s.common.lib.chart.names.fullname" $rootContext) -}}

  {{- if $objectValues.nameOverride -}}
    {{- $override := tpl $objectValues.nameOverride $rootContext -}}
    {{- if not (eq $objectName $override) -}}
      {{- $objectName = printf "%s-%s" $objectName $override -}}
    {{- end -}}
  {{- else -}}
    {{- $enabledPdbs := (include "bjw-s.common.lib.pdb.enabledPdbs" (dict "rootContext" $rootContext) | fromYaml ) }}
    {{- if (gt (len $enabledPdbs) 1) -}}
      {{- if not (eq $objectName $identifier) -}}
        {{- $objectName = printf "%s-%s" $objectName $identifier -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}
  {{- $_ := set $objectValues "name" $objectName -}}
  {{- $_ := set $objectValues "identifier" $identifier -}}

  {{- /* Return the PodDisruptionBudget object */ -}}
  {{- $objectValues | toYaml -}}
{{- end -}}
