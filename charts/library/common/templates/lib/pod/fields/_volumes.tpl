{{- /*
Returns the value for volumes
*/ -}}
{{- define "bjw-s.common.lib.pod.field.volumes" -}}
  {{- $rootContext := .ctx.rootContext -}}
  {{- $componentObject := .ctx.componentObject -}}

  {{- /* Default to empty list */ -}}
  {{- $persistenceItemsToProcess := dict -}}
  {{- $volumes := list -}}

  {{- /* Loop over persistence values */ -}}
  {{- range $identifier, $persistenceValues := $rootContext.Values.persistence -}}
    {{- /* Enable persistence item by default, but allow override */ -}}
    {{- $persistenceEnabled := true -}}
    {{- if hasKey $persistenceValues "enabled" -}}
      {{- $persistenceEnabled = $persistenceValues.enabled -}}
    {{- end -}}

    {{- if $persistenceEnabled -}}
      {{- $hasglobalMounts := not (empty $persistenceValues.globalMounts) -}}
      {{- $globalMounts := dig "globalMounts" list $persistenceValues -}}

      {{- $hasAdvancedMounts := not (empty $persistenceValues.advancedMounts) -}}
      {{- $advancedMounts := dig "advancedMounts" $componentObject.identifier list $persistenceValues -}}

      {{ if or
        ($hasglobalMounts)
        (and ($hasAdvancedMounts) (not (empty $advancedMounts)))
        (and (not $hasglobalMounts) (not $hasAdvancedMounts))
      -}}
        {{- $_ := set $persistenceItemsToProcess $identifier $persistenceValues -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}

  {{- /* Loop over configs values */ -}}
  {{- range $identifier, $configsValues := $rootContext.Values.configs -}}
    {{- /* Enable config item by default, but allow override */ -}}
    {{- $configEnabled := true -}}
    {{- if hasKey $configsValues "enabled" -}}
      {{- $configEnabled = $configsValues.enabled -}}
    {{- end -}}

    {{- if $configEnabled -}}
      {{- $hasglobalMounts := not (empty $configsValues.globalMounts) -}}
      {{- $globalMounts := dig "globalMounts" list $configsValues -}}

      {{- $hasAdvancedMounts := not (empty $configsValues.advancedMounts) -}}
      {{- $advancedMounts := dig "advancedMounts" $componentObject.identifier list $configsValues -}}

      {{ if or
        ($hasglobalMounts)
        (and ($hasAdvancedMounts) (not (empty $advancedMounts)))
        (and (not $hasglobalMounts) (not $hasAdvancedMounts))
      -}}
        {{- $_ := set $persistenceItemsToProcess $identifier $configsValues -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}

  {{- /* Loop over persistence items */ -}}
  {{- range $identifier, $persistenceValues := $persistenceItemsToProcess -}}
    {{- $volume := dict "name" $identifier -}}

    {{- /* PVC persistence type */ -}}
    {{- if eq (default "persistentVolumeClaim" $persistenceValues.type) "persistentVolumeClaim" -}}
      {{- $pvcName := (include "bjw-s.common.lib.chart.names.fullname" $rootContext) -}}
      {{- if $persistenceValues.existingClaim -}}
        {{- /* Always prefer an existingClaim if that is set */ -}}
        {{- $pvcName = $persistenceValues.existingClaim -}}
      {{- else -}}
        {{- /* Otherwise refer to the PVC name */ -}}
        {{- if $persistenceValues.nameOverride -}}
          {{- if not (eq $persistenceValues.nameOverride "-") -}}
            {{- $pvcName = (printf "%s-%s" (include "bjw-s.common.lib.chart.names.fullname" $rootContext) $persistenceValues.nameOverride) -}}
          {{- end -}}
        {{- else -}}
          {{- if not (eq $pvcName $identifier) -}}
            {{- $pvcName = (printf "%s-%s" (include "bjw-s.common.lib.chart.names.fullname" $rootContext) $identifier) -}}
          {{- end -}}
        {{- end -}}
      {{- end -}}
      {{- $_ := set $volume "persistentVolumeClaim" (dict "claimName" $pvcName) -}}

    {{- /* configMap configs type */ -}}
    {{- else if eq $persistenceValues.type "configMap" -}}
      {{- $objectName := "" -}}
      {{- if $persistenceValues.name -}}
        {{- $objectName = tpl $persistenceValues.name $rootContext -}}
      {{- else if $persistenceValues.identifier -}}
        {{- $object := (include "bjw-s.common.lib.configMap.getByIdentifier" (dict "rootContext" $rootContext "id" $persistenceValues.identifier) | fromYaml ) -}}
        {{- if not $object -}}
          {{fail (printf "No configmap found with this identifier. (configs item '%s', identifier '%s')" $identifier $persistenceValues.identifier)}}
        {{- end -}}
        {{- $objectName = $object.name -}}
      {{- end -}}
      {{- $_ := set $volume "configMap" dict -}}
      {{- $_ := set $volume.configMap "name" $objectName -}}
      {{- with $persistenceValues.defaultMode -}}
        {{- $_ := set $volume.configMap "defaultMode" . -}}
      {{- end -}}
      {{- with $persistenceValues.items -}}
        {{- $_ := set $volume.configMap "items" . -}}
      {{- end -}}

    {{- /* Secret configs type */ -}}
    {{- else if eq $persistenceValues.type "secret" -}}
      {{- $objectName := "" -}}
      {{- if $persistenceValues.name -}}
        {{- $objectName = tpl $persistenceValues.name $rootContext -}}
      {{- else if $persistenceValues.identifier -}}
        {{- $object := (include "bjw-s.common.lib.secret.getByIdentifier" (dict "rootContext" $rootContext "id" $persistenceValues.identifier) | fromYaml ) -}}
        {{- if not $object -}}
          {{fail (printf "No secret found with this identifier. (configs item '%s', identifier '%s')" $identifier $persistenceValues.identifier)}}
        {{- end -}}
        {{- $objectName = $object.name -}}
      {{- end -}}
      {{- $_ := set $volume "secret" dict -}}
      {{- $_ := set $volume.secret "secretName" $objectName -}}
      {{- with $persistenceValues.defaultMode -}}
        {{- $_ := set $volume.secret "defaultMode" . -}}
      {{- end -}}
      {{- with $persistenceValues.items -}}
        {{- $_ := set $volume.secret "items" . -}}
      {{- end -}}

      {{- /* ExternalSecret configs type */ -}}
    {{- else if eq $persistenceValues.type "externalsecret" -}}
      {{- $objectName := "" -}}
      {{- if $persistenceValues.name -}}
        {{- $objectName = tpl $persistenceValues.name $rootContext -}}
      {{- else if $persistenceValues.identifier -}}
        {{- $object := (include "bjw-s.common.lib.externalsecret.getByIdentifier" (dict "rootContext" $rootContext "id" $persistenceValues.identifier) | fromYaml ) -}}
        {{- if not $object -}}
          {{fail (printf "No externalsecret found with this identifier. (configs item '%s', identifier '%s')" $identifier $persistenceValues.identifier)}}
        {{- end -}}
        {{- if not (empty (dig "target" "name" nil $object)) -}}
          {{- $objectName = $object.target.name -}}
        {{- else -}}
          {{- $objectName = $object.name -}}
        {{- end -}}
      {{- end -}}
      {{- $_ := set $volume "secret" dict -}}
      {{- $_ := set $volume.secret "secretName" $objectName -}}
      {{- with $persistenceValues.defaultMode -}}
        {{- $_ := set $volume.secret "defaultMode" . -}}
      {{- end -}}
      {{- with $persistenceValues.items -}}
        {{- $_ := set $volume.secret "items" . -}}
      {{- end -}}

    {{- /* emptyDir persistence type */ -}}
    {{- else if eq $persistenceValues.type "emptyDir" -}}
      {{- $_ := set $volume "emptyDir" dict -}}
      {{- with $persistenceValues.medium -}}
        {{- $_ := set $volume.emptyDir "medium" . -}}
      {{- end -}}
      {{- with $persistenceValues.sizeLimit -}}
        {{- $_ := set $volume.emptyDir "sizeLimit" . -}}
      {{- end -}}

    {{- /* hostPath persistence type */ -}}
    {{- else if eq $persistenceValues.type "hostPath" -}}
      {{- $_ := set $volume "hostPath" dict -}}
      {{- $_ := set $volume.hostPath "path" (required "hostPath not set" $persistenceValues.hostPath) -}}
      {{- with $persistenceValues.hostPathType }}
        {{- $_ := set $volume.hostPath "type" . -}}
      {{- end -}}

    {{- /* nfs persistence type */ -}}
    {{- else if eq $persistenceValues.type "nfs" -}}
      {{- $_ := set $volume "nfs" dict -}}
      {{- $_ := set $volume.nfs "server" (required "server not set" $persistenceValues.server) -}}
      {{- $_ := set $volume.nfs "path" (required "path not set" $persistenceValues.path) -}}

    {{- /* custom persistence type */ -}}
    {{- else if eq $persistenceValues.type "custom" -}}
      {{- $volume = tpl (toYaml $persistenceValues.volumeSpec) $rootContext | fromYaml -}}
      {{- $_ := set $volume "name" $identifier -}}

    {{- /* Fail otherwise */ -}}
    {{- else -}}
      {{- fail (printf "Not a valid persistence.type (%s)" $persistenceValues.type) -}}
    {{- end -}}

    {{- $volumes = append $volumes $volume -}}
  {{- end -}}

  {{- if not (empty $volumes) -}}
    {{- $volumes | toYaml -}}
  {{- end -}}
{{- end -}}
