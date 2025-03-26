{{/*
Validate PodDisruptionBudget values
*/}}
{{- define "bjw-s.common.lib.pdb.validate" -}}
  {{- $rootContext := .rootContext -}}
  {{- $pdbObject := .object -}}

  {{- if empty (get $pdbObject "component") -}}
    {{- fail (printf "component field is required for PodDisruptionBudget. (pdb: %s)" $pdbObject.identifier) -}}
  {{- end -}}

  {{- $pdbComponent := include "bjw-s.common.lib.component.getByIdentifier" (dict "rootContext" $rootContext "id" $pdbObject.component) -}}
  {{- if empty $pdbComponent -}}
    {{- fail (printf "No enabled component found with this identifier. (pdb: '%s', component: '%s')" $pdbObject.identifier $pdbObject.component) -}}
  {{- end -}}
{{- end -}}
