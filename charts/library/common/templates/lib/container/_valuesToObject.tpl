{{/*
Convert container values to an object
*/}}
{{- define "bjw-s.common.lib.container.valuesToObject" -}}
  {{- $rootContext := .rootContext -}}
  {{- $componentObject := mustDeepCopy .componentObject -}}
  {{- $containerType := .containerType -}}
  {{- $identifier := .id -}}
  {{- $objectValues := mustDeepCopy .values -}}
  {{- $defaultContainerOptionsStrategy := dig "defaultContainerOptionsStrategy" "overwrite" $componentObject -}}
  {{- $mergeDefaultContainerOptions := true -}}

  {{- $_ := set $objectValues "identifier" $identifier -}}

  {{- /* Allow disabling default options for initContainers */ -}}
  {{- if (eq "init" $containerType) -}}
    {{- $applyDefaultContainerOptionsToInitContainers := dig "applyDefaultContainerOptionsToInitContainers" true $componentObject -}}
    {{- if (not (eq $applyDefaultContainerOptionsToInitContainers true)) -}}
      {{- $mergeDefaultContainerOptions = false -}}
    {{- end -}}
  {{- end -}}

  {{- /* Merge default container options if required */ -}}
  {{- if (eq true $mergeDefaultContainerOptions) -}}
    {{- if eq "overwrite" $defaultContainerOptionsStrategy -}}
      {{- range $key, $defaultValue := (dig "defaultContainerOptions" dict $componentObject) }}
        {{- $specificValue := dig $key nil $objectValues -}}
        {{- if not (empty $specificValue) -}}
          {{- $_ := set $objectValues $key $specificValue -}}
        {{- else -}}
          {{- $_ := set $objectValues $key $defaultValue -}}
        {{- end -}}
      {{- end -}}
    {{- else if eq "merge" $defaultContainerOptionsStrategy -}}
      {{- $objectValues = merge $objectValues (dig "defaultContainerOptions" dict $componentObject) -}}
    {{- end -}}
  {{- end -}}

  {{- /* Process image tags */ -}}
  {{- if kindIs "map" $objectValues.image -}}
    {{- $imageTag := dig "image" "tag" "" $objectValues -}}
    {{- /* Convert float64 image tags to string */ -}}
    {{- if kindIs "float64" $imageTag -}}
      {{- $imageTag = $imageTag | toString -}}
    {{- end -}}

    {{- /* Process any templates in the tag */ -}}
    {{- $imageTag = tpl $imageTag $rootContext -}}

    {{- $_ := set $objectValues.image "tag" $imageTag -}}
  {{- end -}}

  {{- /* Return the container object */ -}}
  {{- $objectValues | toYaml -}}
{{- end -}}
