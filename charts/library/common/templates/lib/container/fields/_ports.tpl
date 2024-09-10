{{/*
Env field used by the container.
*/}}
{{- define "bjw-s.common.lib.container.field.ports" -}}
  {{- $ctx := .ctx -}}
  {{- $rootContext := $ctx.rootContext -}}
  {{- $containerObject := $ctx.containerObject -}}
  {{- $portValues := get $containerObject "ports" -}}

  {{- /* Default to empty list */ -}}
  {{- $portList := list -}}

  {{- /* See if an override is desired */ -}}
  {{- if not (empty $portValues) -}}
    {{- if kindIs "slice" $portValues -}}
      {{- /* Ports is a list so we assume the order is already as desired */ -}}
      {{- $portList = $portValues -}}
    {{- else -}}
      {{- /* Ports is a map so we must parse the different */ -}}

      {{- range $name, $portValue := $portValues -}}
        {{- $portItem := dict "name" $name -}}

        {{- if kindIs "map" $portValue -}}
          {{- $portItem := merge $portItem $portValues -}}
        {{- else -}}
          {{- $_ := set $portItem "containerPort" $portValue -}}
        {{- end -}}

        {{- $portList = append $portList $portItem -}}
      {{- end -}}

    {{- end -}}
  {{- end -}}

  {{- if not (empty $portList) -}}
    {{- $output := list -}}
    {{- range $portList -}}
      {{- if hasKey . "containerPort" -}}
        {{- if kindIs "string" .value -}}
          {{- $output = append $output (dict "name" .name "containerPort" (tpl .containerPort $rootContext)) -}}
        {{- else -}}
          {{- $output = append $output (dict "name" .name "containerPort" .containerPort) -}}
        {{- end -}}
      {{- end -}}
    {{- end -}}
    {{- $output | toYaml -}}
  {{- end -}}
{{- end -}}
