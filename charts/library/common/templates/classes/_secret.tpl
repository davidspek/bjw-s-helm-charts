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
---
apiVersion: v1
kind: Secret
{{- with $secretObject.type }}
type: {{ . }}
{{- end }}
metadata:
  name: {{ $secretObject.name }}
  namespace: {{ $rootContext.Release.Namespace }}
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
{{- with $secretObject.data }}
data:
  {{- tpl (toYaml .) $rootContext | nindent 2 }}
{{- end }}
{{- with $secretObject.stringData }}
stringData:
  {{- tpl (toYaml .) $rootContext | nindent 2 }}
{{- end }}
{{- end -}}
