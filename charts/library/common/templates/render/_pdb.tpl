{{/*
Renders the PodDisruptionBudget objects required by the chart.
*/}}
{{- define "bjw-s.common.render.pdb" -}}
  {{- /* Generate named PodDisruptionBudget as required */ -}}
  {{- range $key, $pdb := .Values.podDisruptionBudgets }}
    {{- /* Enable PDB by default, but allow override */ -}}
    {{- $pdbEnabled := true -}}
    {{- if hasKey $pdb "enabled" -}}
      {{- $pdbEnabled = $pdb.enabled -}}
    {{- end -}}

    {{- if $pdbEnabled -}}
      {{- $pdbValues := (mustDeepCopy $pdb) -}}

      {{- /* Create object from the raw PDB values */ -}}
      {{- $pdbObject := (include "bjw-s.common.lib.pdb.valuesToObject" (dict "rootContext" $ "id" $key "values" $pdbValues)) | fromYaml -}}

      {{- /* Perform validations on the PDB before rendering */ -}}
      {{- include "bjw-s.common.lib.pdb.validate" (dict "rootContext" $ "object" $pdbObject) -}}

      {{/* Include the PodDisruptionBudget class */}}
      {{- include "bjw-s.common.class.pdb" (dict "rootContext" $ "object" $pdbObject) | nindent 0 -}}
    {{- end -}}
  {{- end -}}
{{- end -}}
