{{/* Common labels shared across objects */}}
{{- define "bjw-s.common.lib.metadata.allLabels" -}}
helm.sh/chart: {{ include "bjw-s.common.lib.chart.names.chart" . }}
{{ include "bjw-s.common.lib.metadata.selectorLabels" . }}
{{ include "bjw-s.common.lib.metadata.versionLabel" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{ include "bjw-s.common.lib.metadata.globalLabels" . }}
{{- end -}}

{{/* Common labels shared across objects */}}
{{- define "bjw-s.common.lib.metadata.versionLabel" -}}
  {{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
  {{- end }}
{{- end -}}
