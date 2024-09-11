{{/*
Renders the HorizontalPodAutoscaler objects required by the chart.
*/}}
{{- define "bjw-s.common.render.hpa" -}}
  {{- /* Generate named HorizontalPodAutoscaler as required */ -}}
  {{- range $key, $externalsecret := .Values.externalsecrets }}
    {{- /* Enable Secret by default, but allow override */ -}}
    {{- $externalsecretEnabled := true -}}
    {{- if hasKey $externalsecret "enabled" -}}
      {{- $externalsecretEnabled = $externalsecret.enabled -}}
    {{- end -}}

    {{- if $externalsecretEnabled -}}
      {{- $externalsecretValues := (mustDeepCopy $externalsecret) -}}

      {{- /* Create object from the raw Secret values */ -}}
      {{- $externalsecretObject := (include "bjw-s.common.lib.externalsecret.valuesToObject" (dict "rootContext" $ "id" $key "values" $externalsecretValues)) | fromYaml -}}

      {{- /* Perform validations on the Secret before rendering */ -}}
      {{- include "bjw-s.common.lib.externalsecret.validate" (dict "rootContext" $ "object" $externalsecretObject) -}}

      {{/* Include the Secret class */}}
      {{- include "bjw-s.common.class.externalsecret" (dict "rootContext" $ "object" $externalsecretObject) | nindent 0 -}}
    {{- end -}}
  {{- end -}}
{{- end -}}
