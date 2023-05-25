{{/*
    Common metadata.labels definition.

    For more info see:
      - https://helm.sh/docs/chart_best_practices/labels/#standard-labels
      - https://kubernetes.io/docs/concepts/overview/_print/#labels
*/}}

{{- define "_snippet-metadata-labels-constants" }}
"app.kubernetes.io/name": {{ include "posthog.fullname" . | quote }}
"app.kubernetes.io/instance": {{ .Release.Name | quote }}
"app.kubernetes.io/managed-by": {{ .Release.Service | quote }}
{{- end }}

{{- define "_snippet-metadata-labels-common" }}
{{- include "_snippet-metadata-labels-constants" . }}
"helm.sh/chart": {{ printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" | quote }}
{{- end }}
