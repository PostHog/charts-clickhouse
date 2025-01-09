{{/* Common topologySpreadConstraints definition */}}
{{/*
  matchLabelsKeys are the set of unique pod labels for which the constraints are applied
  any missing labels are ignored.

  pod-template-hash is added automatically by deployments and is unique for each rollout.
  Including this means we don't get out of sync on rollouts as it ignores the locations
  of existing pods that will be terminated after the rollout is finished.
   */}}
{{- define "_snippet-selectors" -}}
labelSelector:
  matchLabels: {}
matchLabelKeys:
- pod-template-hash
- app
- release
- role
- app.kubernetes.io/name
- app.kubernetes.io/instance
{{- end }}
{{- define "_snippet-topologySpreadConstraints" }}
{{- if (.Values.includeDefaultTopologySpreadConstraints | default false) }}
topologySpreadConstraints:
- maxSkew: 2
  topologyKey: topology.kubernetes.io/zone
  whenUnsatisfiable: ScheduleAnyway
  nodeTaintsPolicy: Honor
  {{- include "_snippet-selectors" . | nindent 2 }}
- maxSkew: 5
  topologyKey: kubernetes.io/hostname
  whenUnsatisfiable: ScheduleAnyway
  nodeTaintsPolicy: Honor
  {{- include "_snippet-selectors" . | nindent 2 }}
{{- end }}
{{- end }}
