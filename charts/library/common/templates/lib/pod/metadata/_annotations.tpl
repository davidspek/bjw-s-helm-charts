{{- /*
Returns the value for annotations
*/ -}}
{{- define "bjw-s.common.lib.pod.metadata.annotations" -}}
  {{- $rootContext := .rootContext -}}
  {{- $componentObject := .componentObject -}}

  {{- /* Default annotations */ -}}
  {{- $annotations := dict -}}

  {{- /* Set to the default if it is set */ -}}
  {{- $defaultOption := get (default dict $rootContext.Values.defaultPodOptions) "annotations" -}}
  {{- if not (empty $defaultOption) -}}
    {{- $annotations = merge $defaultOption $annotations -}}
  {{- end -}}

  {{- /* See if a pod-specific override is set */ -}}
  {{- if hasKey $componentObject "pod" -}}
    {{- $podOption := get $componentObject.pod "annotations" -}}
    {{- if not (empty $podOption) -}}
      {{- $annotations = merge $podOption $annotations -}}
    {{- end -}}
  {{- end -}}

  {{- /* Add configMaps checksum */ -}}
  {{- $configMapsFound := dict -}}
  {{- range $name, $configmap := $rootContext.Values.configMaps -}}
    {{- $configMapEnabled := true -}}
    {{- if hasKey $configmap "enabled" -}}
      {{- $configMapEnabled = $configmap.enabled -}}
    {{- end -}}
    {{- $configMapIncludeInChecksum := true -}}
    {{- if hasKey $configmap "includeInChecksum" -}}
      {{- $configMapIncludeInChecksum = $configmap.includeInChecksum -}}
    {{- end -}}
    {{- if and $configMapEnabled $configMapIncludeInChecksum -}}
      {{- $_ := set $configMapsFound $name (toYaml $configmap.data | sha256sum) -}}
    {{- end -}}
  {{- end -}}
  {{- if $configMapsFound -}}
    {{- $annotations = merge
      (dict "checksum/configMaps" (toYaml $configMapsFound | sha256sum))
      $annotations
    -}}
  {{- end -}}

  {{- /* Add Secrets checksum */ -}}
  {{- $secretsFound := dict -}}
  {{- range $name, $secret := $rootContext.Values.secrets -}}
    {{- $secretEnabled := true -}}
    {{- if hasKey $secret "enabled" -}}
      {{- $secretEnabled = $secret.enabled -}}
    {{- end -}}
    {{- $secretIncludeInChecksum := true -}}
    {{- if hasKey $secret "includeInChecksum" -}}
      {{- $secretIncludeInChecksum = $secret.includeInChecksum -}}
    {{- end -}}
    {{- if and $secretEnabled $secretIncludeInChecksum -}}
      {{- $_ := set $secretsFound $name (toYaml $secret.stringData | sha256sum) -}}
    {{- end -}}
  {{- end -}}
  {{- if $secretsFound -}}
    {{- $annotations = merge
      (dict "checksum/secrets" (toYaml $secretsFound | sha256sum))
      $annotations
    -}}
  {{- end -}}

  {{- if not (empty $annotations) -}}
    {{- $outAnnotations := dict -}}
    {{- with $annotations -}}
      {{- range $key, $value := . -}}
      {{- $outAnnotations = merge $outAnnotations (dict $key (tpl $value $rootContext | toYaml )) -}}
      {{- end -}}
    {{- end -}}
    {{- $outAnnotations | toYaml -}}
  {{- end -}}
{{- end -}}
