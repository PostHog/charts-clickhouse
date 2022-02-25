{{/* Common Kafka ENV variables and helpers used by PostHog */}}

{{/* Return the Kafka fullname */}}
{{- define "posthog.kafka.fullname" -}}
{{- if .Values.kafka.fullnameOverride -}}
{{- .Values.kafka.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else if .Values.kafka.nameOverride -}}
{{- printf "%s-%s" .Release.Name .Values.kafka.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" (include "posthog.fullname" .) "kafka" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/* Return the Kafka hosts (brokers) */}}
{{- define "posthog.kafka.brokers" -}}
{{- if .Values.kafka.enabled }}
    {{- printf "%s:%d" (include "posthog.kafka.fullname" .) (.Values.kafka.service.port | int) -}}
{{- else -}}
    {{- printf "%s" .Values.externalKafka.brokers -}}
{{- end -}}
{{- end -}}

{{/* ENV used by PostHog deployments for connecting to Kafka */}}
{{- define "snippet.kafka-env" }}
- name: KAFKA_HOSTS
  value: "{{ include "posthog.kafka.brokers" . }}"
- name: KAFKA_URL
  value: "kafka://{{ include "posthog.kafka.brokers" . }}"
- name: KAFKA_ENABLED
  value: "true"
{{- end }}
