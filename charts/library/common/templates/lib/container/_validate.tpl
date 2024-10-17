{{/*
Validate container values
*/}}
{{- define "bjw-s.common.lib.container.validate" -}}
  {{- $rootContext := .rootContext -}}
  {{- $componentObject := .componentObject -}}
  {{- $containerObject := .containerObject -}}

  {{- if not (kindIs "map" $containerObject.image)  -}}
    {{- fail (printf "Image required to be a dictionary with repository and tag fields. (component %s, container %s)" $componentObject.identifier $containerObject.identifier) }}
  {{- end -}}

  {{- if empty (dig "image" "repository" nil $containerObject) -}}
    {{- fail (printf "No image repository specified for container. (component %s, container %s)" $componentObject.identifier $containerObject.identifier) }}
  {{- end -}}

  {{- if empty (dig "image" "tag" nil $containerObject) -}}
    {{- fail (printf "No image tag specified for container. (component %s, container %s)" $componentObject.identifier $containerObject.identifier) }}
  {{- end -}}
{{- end -}}
