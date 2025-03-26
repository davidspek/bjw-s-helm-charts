{{/*
Convert Deployment values to an object
*/}}
{{- define "bjw-s.common.lib.deployment.valuesToObject" -}}
  {{- $rootContext := .rootContext -}}
  {{- $identifier := .id -}}
  {{- $objectValues := .values -}}

  {{- $strategy := default "RollingUpdate" $objectValues.strategy -}}
  {{- $_ := set $objectValues "strategy" $strategy -}}
  {{- if (dig "autoscaling" "enabled" false $objectValues) -}}
  {{- $_ := set $objectValues "replicas" nil -}}
  {{- end -}}

  {{- /* Return the Deployment object */ -}}
  {{- $objectValues | toYaml -}}
{{- end -}}
