{{/* Common Temporal ENV variables and helpers used by PostHog */}}

{{/* Return the Temporal fullname */}}
{{- define "posthog.temporal.fullname" }}
{{- if .Values.temporal.fullnameOverride }}
{{- .Values.temporal.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else if .Values.temporal.nameOverride }}
{{- printf "%s-%s" .Release.Name .Values.temporal.nameOverride | trunc 63 | trimSuffix "-" }}
{{- else -}}
{{- printf "%s-%s" (include "posthog.fullname" .) "temporal" | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{/* Return the Temporal hosts as a comma separated list */}}
{{- define "posthog.temporal.host"}}
{{- if .Values.temporal.enabled -}}
    {{- printf "%s-frontend" (include "posthog.temporal.fullname" .) }}
{{- else -}}
    {{ .Values.externalTemporal.host | quote }}
{{- end }}
{{- end }}

{{/* ENV used by PostHog deployments for connecting to Temporal */}}

{{- define "snippet.temporal-env" }}
{{- if .Values.temporal.enabled }}
- name: TEMPORAL_HOST
  value: {{ ( include "posthog.temporal.host" . ) }}
- name: TEMPORAL_PORT
  value: "7233"
- name: TEMPORAL_NAMESPACE
  value: "default"
{{ else }}
- name: TEMPORAL_HOST
  value: {{ .Values.externalTemporal.host | quote }}
- name: TEMPORAL_PORT
  value: {{ .Values.externalTemporal.port | quote }}
- name: TEMPORAL_NAMESPACE
  value: {{ .Values.externalTemporal.namespace | quote }}
{{- end }}
{{- end }}
