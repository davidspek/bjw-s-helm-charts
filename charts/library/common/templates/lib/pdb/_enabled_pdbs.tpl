{{/*
Return the enabled PodDisruptionBudgets.
*/}}
{{- define "bjw-s.common.lib.pdb.enabledPdbs" -}}
  {{- $rootContext := .rootContext -}}
  {{- $enabledPdbs := dict -}}

  {{- range $name, $pdb := $rootContext.Values.podDisruptionBudgets -}}
    {{- if kindIs "map" $pdb -}}
      {{- /* Enable PodDisruptionBudgets by default, but allow override */ -}}
      {{- $pdbEnabled := true -}}
      {{- if hasKey $pdb "enabled" -}}
        {{- $pdbEnabled = $pdb.enabled -}}
      {{- end -}}

      {{- if $pdbEnabled -}}
        {{- $_ := set $enabledPdbs $name . -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}

  {{- $enabledPdbs | toYaml -}}
{{- end -}}
