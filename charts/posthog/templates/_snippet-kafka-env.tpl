{{/* Common Kafka ENV variables */}}
{{- define "snippet.kafka-env" }}

- name: KAFKA_HOSTS
  value: "{{ include "posthog.kafka.brokers" . }}"

- name: KAFKA_URL
  value: "kafka://{{ include "posthog.kafka.brokers" . }}"

- name: KAFKA_ENABLED
  value: "true"

{{- end }}
