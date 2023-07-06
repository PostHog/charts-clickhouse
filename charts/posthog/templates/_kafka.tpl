{{/* Common Kafka ENV variables and helpers used by PostHog */}}

{{/* Return the Kafka fullname */}}
{{- define "posthog.kafka.fullname" }}
{{- if .Values.kafka.fullnameOverride }}
{{- .Values.kafka.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else if .Values.kafka.nameOverride }}
{{- printf "%s-%s" .Release.Name .Values.kafka.nameOverride | trunc 63 | trimSuffix "-" }}
{{- else -}}
{{- printf "%s-%s" (include "posthog.fullname" .) "kafka" | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{/* Return the Kafka hosts (brokers) as a comma separated list */}}
{{- define "posthog.kafka.brokers"}}
{{- if .Values.kafka.enabled -}}
{{- printf "%s:%d" (include "posthog.kafka.fullname" .) (.Values.kafka.service.port | int) }}
{{- else -}}
{{ join "," .Values.externalKafka.brokers | quote }}
{{- end }}
{{- end }}

{{/* Return the Kafka hosts (brokers) as a comma separated list */}}
{{- define "posthog.sessionRecordingKafka.brokers"}}
{{- if .Values.kafka.enabled -}}
{{- printf "%s:%d" (include "posthog.kafka.fullname" .) (.Values.kafka.service.port | int) }}
{{- else -}}
{{ join "," .Values.externalSessionRecordingKafka.brokers | quote }}
{{- end }}
{{- end }}

{{/* ENV used by PostHog deployments for connecting to Kafka */}}
{{- define "snippet.kafka-env" }}
{{- $hostsWithPrefix := list }}
{{- range $host := .Values.externalKafka.brokers }}
{{- $hostWithPrefix := (printf "kafka://%s" $host) }}
{{- $hostsWithPrefix = append $hostsWithPrefix $hostWithPrefix }}
{{- end }}

# NOTE: This is deprecated and KAFKA_HOSTS should be used instead but whilst the chart is still available we need to keep this for backwards compatibility
- name: KAFKA_URL
{{- if .Values.kafka.enabled }}
  value: {{ printf "kafka://%s" ( include "posthog.kafka.brokers" . ) }}
{{ else }}
  value: {{ join "," $hostsWithPrefix | quote }}
{{- end }}

# Used by PostHog/plugin-server. Expected format: comma-separated list of "host:port"
- name: KAFKA_HOSTS
  value: {{ ( include "posthog.kafka.brokers" . ) }}

# Used by PostHog/plugin-server when running a recordings workload. Expected format: comma-separated list of "host:port"
- name: SESSION_RECORDING_KAFKA_HOSTS
  value: {{ ( include "posthog.sessionRecordingKafka.brokers" . ) }}

{{- if and (not .Values.kafka.enabled) .Values.externalKafka.tls }}
- name: KAFKA_SECURITY_PROTOCOL
  value: SSL
{{- end }}

{{- if and (not .Values.kafka.enabled) .Values.externalSessionRecordingKafka.tls }}
- name: SESSION_RECORDING_KAFKA_SECURITY_PROTOCOL
  value: SSL
{{- end }}
{{- end }}