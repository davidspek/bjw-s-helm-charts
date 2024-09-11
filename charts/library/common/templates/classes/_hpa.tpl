{{/*
This template serves as a blueprint for all HorizontalPodAutoscaler objects that are created
within the common library.
*/}}
{{- define "bjw-s.common.class.hpa" -}}
  {{- $rootContext := .rootContext -}}
  {{- $hpaObject := .object -}}

  {{- $labels := merge
    ($hpaObject.labels | default dict)
    (include "bjw-s.common.lib.metadata.allLabels" $rootContext | fromYaml)
  -}}
  {{- $annotations := merge
    ($hpaObject.annotations | default dict)
    (include "bjw-s.common.lib.metadata.globalAnnotations" $rootContext | fromYaml)
  -}}
  {{- $componentObject := include "bjw-s.common.lib.component.getByIdentifier" (dict "rootContext" $rootContext "id" $hpaObject.identifier) | fromYaml -}}
  {{ $targetKind := "Deployment" }}
  {{- if eq $componentObject.type "statefulset" }}
  {{ $targetKind = "StatefulSet" }}
  {{- end }}
---
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: {{ $hpaObject.name }}
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
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: {{ $targetKind }}
    name: {{ $componentObject.name }}
  {{- with $hpaObject.minReplicas }}
  minReplicas: {{ . }}
  {{- end }}
  maxReplicas: {{ $hpaObject.maxReplicas }}
  {{- with $hpaObject.metrics }}
  metrics:
    {{- toYaml . | nindent 2 }}
  {{- end }}
  {{- with $hpaObject.behavior }}
  behavior:
    {{- toYaml . | nindent 4 }}
  {{- end }}
{{- end -}}
