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
      {{- /* Ports is a list so we assume it is valid */ -}}
      {{- range $idx, $port := $portValues -}}
        {{- if kindIs "int" $idx -}}
          {{- $idx = required "ports as a list of maps require a containerPort field" $port.containerPort -}}
        {{- end -}}
      {{- end -}}
      {{- $portList = $portValues -}}
    {{- else -}}
      {{- /* Ports is a map so we must parse the different */ -}}

      {{- range $name, $portValue := $portValues -}}
        {{- $portName := $name -}}
        {{- $portItem := dict "name" $portName -}}

        {{- if kindIs "map" $portValue -}}
          {{- $portItem := mergeOverwrite $portItem $portValue -}}
        {{- else -}}
          {{- if kindIs "string" $portValue -}}
            {{- $_ := set $portItem "containerPort" (tpl $portValue $rootContext | int64) -}}
          {{- else -}}
            {{- $_ := set $portItem "containerPort" $portValue -}}
          {{- end -}}
        {{- end -}}

        {{- $portList = append $portList $portItem -}}
      {{- end -}}

    {{- end -}}
  {{- end -}}

  {{- if not (empty $portList) -}}
    {{- $output := list -}}
    {{- range $portList -}}
      {{- if hasKey . "containerPort" -}}
        {{- $output = append $output (merge . (dict "name" .name "containerPort" .containerPort)) -}}
      {{- end -}}
    {{- end -}}
    {{- $output | toYaml -}}
  {{- end -}}
{{- end -}}
