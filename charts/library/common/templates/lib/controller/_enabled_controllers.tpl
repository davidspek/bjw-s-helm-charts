{{/*
Return the enabled components.
*/}}
{{- define "bjw-s.common.lib.component.enabledComponents" -}}
  {{- $rootContext := .rootContext -}}
  {{- $enabledComponents := dict -}}

  {{- range $name, $component := $rootContext.Values.components -}}
    {{- if kindIs "map" $component -}}
      {{- /* Enable by default, but allow override */ -}}
      {{- $componentEnabled := true -}}
      {{- if hasKey $component "enabled" -}}
        {{- $componentEnabled = $component.enabled -}}
      {{- end -}}

      {{- if $componentEnabled -}}
        {{- $_ := set $enabledComponents $name . -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}

  {{- $enabledComponents | toYaml -}}
{{- end -}}
