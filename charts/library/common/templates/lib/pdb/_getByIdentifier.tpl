{{/*
Return a PodDisruptionBudget Object by its Identifier.
*/}}
{{- define "bjw-s.common.lib.pdb.getByIdentifier" -}}
  {{- $rootContext := .rootContext -}}
  {{- $identifier := .id -}}

  {{- $pdbValues := dig $identifier nil $rootContext.Values.podDisruptionBudgets -}}
  {{- if not (empty $pdbValues) -}}
    {{- include "bjw-s.common.lib.pdb.valuesToObject" (dict "rootContext" $rootContext "id" $identifier "values" $pdbValues) -}}
  {{- end -}}
{{- end -}}
