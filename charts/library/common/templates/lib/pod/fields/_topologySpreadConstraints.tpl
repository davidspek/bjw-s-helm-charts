{{- /*
Returns the value for topologySpreadConstraints
*/ -}}
{{- define "bjw-s.common.lib.pod.field.topologySpreadConstraints" -}}
  {{- $ctx := .ctx -}}
  {{- $rootContext := .rootContext -}}
  {{- $componentObject := $ctx.componentObject -}}

  {{- /* Default labels */ -}}
  {{- $labels := merge
    (dict "app.kubernetes.io/component" $componentObject.identifier)
  -}}

  {{- /* Fetch the Pod selectorLabels */ -}}
  {{- $selectorLabels := include "bjw-s.common.lib.metadata.selectorLabels" $rootContext | fromYaml -}}
  {{- if not (empty $selectorLabels) -}}
    {{- $labels = merge $selectorLabels $labels -}}
  {{- end -}}

  {{- /* Default to empty list */ -}}
  {{- $tscList := list -}}


  {{- /* Get topologySpreadConstraints value "" */ -}}
  {{- $spreadConstraints := include "bjw-s.common.lib.pod.getOption" (dict "ctx" $ctx "option" "topologySpreadConstraints") | fromYamlArray -}}
  {{- range $tsc := $spreadConstraints -}}
    {{- if empty (get $tsc "labelSelector") -}}
      {{- $_ := set $tsc "labelSelector" (dict "matchLabels" $labels) -}}
    {{- end -}}
    {{- $tscList = append $tscList $tsc -}}
  {{- end -}}

  {{- if not (empty $tscList) -}}
    {{- $tscList | toYaml -}}
  {{- end -}}
{{- end -}}
