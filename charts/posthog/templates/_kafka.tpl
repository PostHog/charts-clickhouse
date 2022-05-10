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

{{/* Return the Kafka hosts (brokers) */}}
{{- define "posthog.kafka.brokers"}}
{{- if .Values.kafka.enabled -}}
    {{- printf "%s:%d" (include "posthog.kafka.fullname" .) (.Values.kafka.service.port | int) }}
{{- else -}}
    {{- printf "%s" .Values.externalKafka.brokers }}
{{- end }}
{{- end }}

{{/* ENV used by PostHog deployments for connecting to Kafka */}}

{{- define "snippet.kafka-env" }}

{{- $hostsWithPrefix := list }}
{{- range $host := .Values.externalKafka.brokers }}
{{- $hostWithPrefix := (printf "kafka://%s" $host) }}
{{- $hostsWithPrefix = append $hostsWithPrefix $hostWithPrefix }}
{{- end }}
- name: KAFKA_ENABLED
  value: "true"
# Used by PostHog/plugin-server. There is no specific reason for the difference. Expected format: comma-separated list of "host:port"
- name: KAFKA_HOSTS
{{- if .Values.kafka.enabled }}
  value: {{ ( include "posthog.kafka.brokers" . ) }}
{{ else }}
  value: {{ join "," .Values.externalKafka.brokers | quote }}
{{- end }}
# Used by PostHog/web. There is no specific reason for the difference. Expected format: comma-separated list of "kafka://host:port"
- name: KAFKA_URL
{{- if .Values.kafka.enabled }}
  value: {{ printf "kafka://%s" ( include "posthog.kafka.brokers" . ) }}
{{ else }}
  value: {{ join "," $hostsWithPrefix | quote }}
{{- end }}
{{- if .Values.externalKafka.mtls.secretName }}
- name: KAFKA_BASE64_KEYS
  value: "true"
- name: KAFKA_CLIENT_CERT_B64
  valueFrom:
    secretKeyRef:
      name: {{ .Values.externalKafka.mtls.secretName }}
      key: {{ .Values.externalKafka.mtls.certKey }}
- name: KAFKA_CLIENT_CERT_KEY_B64
  valueFrom:
    secretKeyRef:
      name: {{ .Values.externalKafka.mtls.secretName }}
      key: {{ .Values.externalKafka.mtls.certKeyKey }}
- name: KAFKA_TRUSTED_CERT_B64
  valueFrom:
    secretKeyRef:
      name: {{ .Values.externalKafka.mtls.secretName }}
      key: {{ .Values.externalKafka.mtls.trustedCertKey }}
{{ else }}
- name: KAFKA_BASE64_KEYS
  value: "false"
{{- end }}
{{- end }}
