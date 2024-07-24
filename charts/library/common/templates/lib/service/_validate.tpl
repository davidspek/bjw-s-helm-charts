{{/*
Validate Service values
*/}}
{{- define "bjw-s.common.lib.service.validate" -}}
  {{- $rootContext := .rootContext -}}
  {{- $serviceObject := .object -}}

  {{- if empty (get $serviceObject "component") -}}
    {{- fail (printf "component field is required for Service. (service: %s)" $serviceObject.identifier) -}}
  {{- end -}}

  {{- $serviceComponent := include "bjw-s.common.lib.component.getByIdentifier" (dict "rootContext" $rootContext "id" $serviceObject.component) -}}
  {{- if empty $serviceComponent -}}
    {{- fail (printf "No enabled component found with this identifier. (service: '%s', component: '%s')" $serviceObject.identifier $serviceObject.component) -}}
  {{- end -}}

  {{- /* Validate Service type */ -}}
  {{- $validServiceTypes := (list "ClusterIP" "LoadBalancer" "NodePort" "ExternalName" "ExternalIP") -}}
  {{- if and $serviceObject.type (not (mustHas $serviceObject.type $validServiceTypes)) -}}
    {{- fail (
      printf "invalid service type \"%s\" for Service with key \"%s\". Allowed values are [%s]"
      $serviceObject.type
      $serviceObject.identifier
      (join ", " $validServiceTypes)
    ) -}}
  {{- end -}}

  {{- if ne $serviceObject.type "ExternalName" -}}
    {{- $enabledPorts := include "bjw-s.common.lib.service.enabledPorts" (dict "rootContext" $rootContext "serviceObject" $serviceObject) | fromYaml }}
    {{- /* Validate at least one port is enabled */ -}}
    {{- if not $enabledPorts -}}
      {{- fail (printf "no ports are enabled for Service with key \"%s\"" $serviceObject.identifier) -}}
    {{- end -}}

    {{- range $name, $port := $enabledPorts -}}
      {{- /* Validate a port number is configured */ -}}
      {{- if not $port.port -}}
        {{- fail (printf "no port number is configured for port \"%s\" under Service with key \"%s\"" $name $serviceObject.identifier) -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}
{{- end -}}
