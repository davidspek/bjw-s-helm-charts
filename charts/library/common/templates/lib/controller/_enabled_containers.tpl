{{/*
Return the enabled containers for a component.
*/}}
{{- define "bjw-s.common.lib.component.enabledContainers" -}}
  {{- $rootContext := .rootContext -}}
  {{- $componentObject := .componentObject -}}

  {{- $enabledContainers := dict -}}
  {{- range $name, $container := $componentObject.containers -}}
    {{- if kindIs "map" $container -}}
      {{- /* Enable container by default, but allow override */ -}}
      {{- $containerEnabled := true -}}
      {{- if hasKey $container "enabled" -}}
        {{- $containerEnabled = $container.enabled -}}
      {{- end -}}

      {{- if $containerEnabled -}}
        {{- $_ := set $enabledContainers $name $container -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}

  {{- $enabledContainers | toYaml -}}
{{- end -}}
