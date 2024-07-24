{{- define "bjw-s.common.lib.component.metadata.labels" -}}
  {{-
    $labels := (
      merge
        (.Values.component.labels | default dict)
        (include "bjw-s.common.lib.metadata.allLabels" $ | fromYaml)
    )
  -}}
  {{- with $labels -}}
    {{- toYaml . -}}
  {{- end -}}
{{- end -}}

{{- define "bjw-s.common.lib.component.metadata.annotations" -}}
  {{-
    $annotations := (
      merge
        (.Values.component.annotations | default dict)
        (include "bjw-s.common.lib.metadata.globalAnnotations" $ | fromYaml)
    )
  -}}
  {{- with $annotations -}}
    {{- toYaml . -}}
  {{- end -}}
{{- end -}}
