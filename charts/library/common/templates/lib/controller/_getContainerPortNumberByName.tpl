{{/*
Return a container port number by name for a Container from a Component object
*/}}
{{- define "bjw-s.common.lib.component.getContainerPortNumberByName" -}}
  {{- $rootContext := .rootContext -}}
  {{- $componentIdentifier := .componentIdentifier -}}
  {{- $containerIdentifier := .containerIdentifier -}}
  {{- $portName := .portName -}}

  {{- $componentObject := include "bjw-s.common.lib.component.getByIdentifier" (dict "rootContext" $rootContext "id" $componentIdentifier) | fromYaml -}}
  {{- if $componentObject -}}
    {{- $containerObject := include "bjw-s.common.lib.component.getContainerByIdentifier" (dict "rootContext" $rootContext "componentObject" $componentObject "id" $containerIdentifier) | fromYaml -}}
    {{- if $containerObject -}}
      {{- $ctx := dict "rootContext" $rootContext "componentObject" $componentObject "containerObject" $containerObject -}}
      {{- $containerPorts := include "bjw-s.common.lib.container.field.ports" (dict "ctx" $ctx "rootContext" $rootContext) | fromYamlArray -}}
      {{- if $containerPorts -}}
        {{- range $port := $containerPorts -}}
          {{- if eq $port.name $portName -}}
            {{- $port.containerPort -}}
          {{- end -}}
        {{- end -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}
{{- end -}}
