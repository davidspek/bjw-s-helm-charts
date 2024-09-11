{{/*
Renders the component objects required by the chart.
*/}}
{{- define "bjw-s.common.render.components" -}}
  {{- /* Generate named component objects as required */ -}}
  {{- range $key, $component := .Values.components -}}
    {{- /* Enable component by default, but allow override */ -}}
    {{- $componentEnabled := true -}}
    {{- if hasKey $component "enabled" -}}
      {{- $componentEnabled = $component.enabled -}}
    {{- end -}}

    {{- if $componentEnabled -}}
      {{- $componentValues := $component -}}

      {{- /* Create object from the raw component values */ -}}
      {{- $componentObject := (include "bjw-s.common.lib.component.valuesToObject" (dict "rootContext" $ "id" $key "values" $componentValues)) | fromYaml -}}

      {{- /* Perform validations on the component before rendering */ -}}
      {{- include "bjw-s.common.lib.component.validate" (dict "rootContext" $ "object" $componentObject) -}}

      {{- if eq $componentObject.type "deployment" -}}
        {{- $deploymentObject := (include "bjw-s.common.lib.deployment.valuesToObject" (dict "rootContext" $ "id" $key "values" $componentObject)) | fromYaml -}}
        {{- include "bjw-s.common.lib.deployment.validate" (dict "rootContext" $ "object" $deploymentObject) -}}
        {{- include "bjw-s.common.class.deployment" (dict "rootContext" $ "object" $deploymentObject) | nindent 0 -}}
      {{- else if eq $componentObject.type "cronjob" -}}
        {{- $cronjobObject := (include "bjw-s.common.lib.cronjob.valuesToObject" (dict "rootContext" $ "id" $key "values" $componentObject)) | fromYaml -}}
        {{- include "bjw-s.common.lib.cronjob.validate" (dict "rootContext" $ "object" $cronjobObject) -}}
        {{- include "bjw-s.common.class.cronjob" (dict "rootContext" $ "object" $cronjobObject) | nindent 0 -}}
      {{- else if eq $componentObject.type "daemonset" -}}
        {{- $daemonsetObject := (include "bjw-s.common.lib.daemonset.valuesToObject" (dict "rootContext" $ "id" $key "values" $componentObject)) | fromYaml -}}
        {{- include "bjw-s.common.lib.daemonset.validate" (dict "rootContext" $ "object" $daemonsetObject) -}}
        {{- include "bjw-s.common.class.daemonset" (dict "rootContext" $ "object" $daemonsetObject) | nindent 0 -}}
      {{- else if eq $componentObject.type "statefulset" -}}
        {{- $statefulsetObject := (include "bjw-s.common.lib.statefulset.valuesToObject" (dict "rootContext" $ "id" $key "values" $componentObject)) | fromYaml -}}
        {{- include "bjw-s.common.lib.statefulset.validate" (dict "rootContext" $ "object" $statefulsetObject) -}}
        {{- include "bjw-s.common.class.statefulset" (dict "rootContext" $ "object" $statefulsetObject) | nindent 0 -}}
      {{- else if eq $componentObject.type "job"  -}}
        {{- $jobObject := (include "bjw-s.common.lib.job.valuesToObject" (dict "rootContext" $ "id" $key "values" $componentObject)) | fromYaml -}}
        {{- include "bjw-s.common.lib.job.validate" (dict "rootContext" $ "object" $jobObject) -}}
        {{- include "bjw-s.common.class.job" (dict "rootContext" $ "object" $jobObject) | nindent 0 -}}
      {{- end -}}

      {{- if $componentObject.autoscaling.enabled -}}
        {{- if eq $componentObject.autoscaling.type "hpa" -}}
          {{- $hpaObject := (include "bjw-s.common.lib.hpa.valuesToObject" (dict "rootContext" $ "id" $key "values" $componentObject.autoscaling.hpa)) | fromYaml -}}
          {{- include "bjw-s.common.lib.hpa.validate" (dict "rootContext" $ "object" $hpaObject) -}}
          {{- include "bjw-s.common.class.hpa" (dict "rootContext" $ "object" $hpaObject) | nindent 0 -}}
        {{- end -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}
{{- end -}}
