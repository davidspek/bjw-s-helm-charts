{{/*
This template serves as a blueprint for all PodDisruptionBudget objects that are created
within the common library.
*/}}
{{- define "bjw-s.common.class.pdb" -}}
  {{- $rootContext := .rootContext -}}
  {{- $pdbObject := .object -}}

  {{- $labels := merge
    ($pdbObject.labels | default dict)
    (include "bjw-s.common.lib.metadata.allLabels" $rootContext | fromYaml)
  -}}
  {{- $annotations := merge
    ($pdbObject.annotations | default dict)
    (include "bjw-s.common.lib.metadata.globalAnnotations" $rootContext | fromYaml)
  -}}
---
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: {{ $pdbObject.name }}
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
  {{- with $pdbObject.minAvailable }}
  minAvailable: {{ $pdbObject.minAvailable }}
  {{- end }}
  {{- with $pdbObject.maxUnavailable }}
  maxUnavailable: {{ $pdbObject.maxUnavailable }}
  {{- end }}
  {{- with $pdbObject.unhealthyPodEvictionPolicy }}
  unhealthyPodEvictionPolicy: {{ $pdbObject.unhealthyPodEvictionPolicy }}
  {{- end }}
  {{- with (merge
    (dict "app.kubernetes.io/component" $pdbObject.component)
    (include "bjw-s.common.lib.metadata.selectorLabels" $rootContext | fromYaml)
  ) }}
  selector:
    matchLabels: {{- toYaml . | nindent 6 }}
  {{- end }}
{{- end }}
