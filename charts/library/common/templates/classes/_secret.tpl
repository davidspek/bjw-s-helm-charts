{{/*
This template serves as a blueprint for all Secret objects that are created
within the common library.
*/}}
{{- define "bjw-s.common.class.secret" -}}
  {{- $rootContext := .rootContext -}}
  {{- $secretObject := .object -}}

  {{- $labels := merge
    ($secretObject.labels | default dict)
    (include "bjw-s.common.lib.metadata.allLabels" $rootContext | fromYaml)
  -}}
  {{- $annotations := merge
    ($secretObject.annotations | default dict)
    (include "bjw-s.common.lib.metadata.globalAnnotations" $rootContext | fromYaml)
  -}}

  {{- $stringData := "" -}}
  {{- with $secretObject.stringData -}}
    {{- $stringData = (toYaml $secretObject.stringData) | trim -}}
  {{- end -}}

  {{- $data := "" -}}
  {{- if hasKey $secretObject "data" -}}
  {{- with $secretObject.data -}}
    {{- $data = (toYaml $secretObject.data) | trim -}}
  {{- end -}}
  {{- end -}}
---
apiVersion: v1
kind: Secret
{{- with $secretObject.type }}
type: {{ . }}
{{- end }}
metadata:
  name: {{ $secretObject.name }}
  namespace: {{ .Release.Namespace }}
  {{- with $labels }}
  labels:
    {{- range $key, $value := . }}
    {{- printf "%s: %s" $key (tpl $value $rootContext | toYaml ) | nindent 4 }}
    {{- end }}
  {{- end }}
  {{- with $annotations }}
  annotations:
    {{- range $key, $value := . }}
    {{- printf "%s: %s" $key (tpl $value $rootContext | toYaml ) | nindent 4 }}
    {{- end }}
  {{- end }}
{{- if $data }}
{{- with $data }}
data: {{- tpl $data $rootContext | nindent 2 }}
{{- end }}
{{- else if $stringData }}
{{- with $stringData }}
stringData: {{- tpl $stringData $rootContext | nindent 2 }}
{{- end }}
{{- end }}
{{- end -}}
