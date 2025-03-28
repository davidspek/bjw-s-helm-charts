{{- /*
Returns the value for annotations
*/ -}}
{{- define "bjw-s.common.lib.pod.metadata.annotations" -}}
  {{- $rootContext := .rootContext -}}
  {{- $componentObject := .componentObject -}}

  {{- /* Default annotations */ -}}
  {{- $annotations := merge
    (dict)
  -}}

  {{- /* Include global annotations if specified */ -}}
  {{- if $rootContext.Values.global.propagateGlobalMetadataToPods -}}
    {{- $annotations = merge
      (include "bjw-s.common.lib.metadata.globalAnnotations" $rootContext | fromYaml)
      $annotations
    -}}
  {{- end -}}

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
      {{- $_ := set $configMapsFound $name (tpl (toYaml $configmap.data) $rootContext | sha256sum) -}}
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
      {{- if hasKey $secret "data" -}}
        {{- $_ := set $secretsFound $name (tpl (toYaml $secret.data) $rootContext | sha256sum) -}}
      {{- else if hasKey $secret "stringData" -}}
        {{- $_ := set $secretsFound $name (tpl (toYaml $secret.stringData) $rootContext | sha256sum) -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}
  {{- range $name, $externalsecret := $rootContext.Values.externalsecrets -}}
    {{- $externalsecretEnabled := true -}}
    {{- if hasKey $externalsecret "enabled" -}}
      {{- $externalsecretEnabled = $externalsecret.enabled -}}
    {{- end -}}
    {{- $externalsecretIncludeInChecksum := true -}}
    {{- if hasKey $externalsecret "includeInChecksum" -}}
      {{- $externalsecretIncludeInChecksum = $externalsecret.includeInChecksum -}}
    {{- end -}}
    {{- if and $externalsecretEnabled $externalsecretIncludeInChecksum -}}
      {{- $_ := set $secretsFound $name (toYaml $externalsecret | sha256sum) -}}
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
      {{- $outAnnotations = merge $outAnnotations (dict $key (tpl $value $rootContext)) -}}
      {{- end -}}
    {{- end -}}
    {{- $outAnnotations | toYaml -}}
  {{- end -}}
{{- end -}}
