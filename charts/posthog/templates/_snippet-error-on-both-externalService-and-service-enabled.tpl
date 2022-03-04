{{/* Raise an error if externalService is configured without service.enabled being false. */}}
{{- define "snippet.error-on-both-externalService-and-service-enabled" }}
{{- if and .Values.postgresql.enabled .Values.externalPostgresql.postgresqlHost }}
    {{- required (printf (include "snippet.error-on-both-externalService-and-service-enabled-template" .) "externalPostgresql.postgresqlHost cannot be set if postgresql.enabled is true") nil -}}
{{- else if and .Values.redis.enabled .Values.externalRedis.host }}
    {{- required (printf (include "snippet.error-on-both-externalService-and-service-enabled-template" .) "externalRedis.host cannot be set if redis.enabled is true") nil -}}
{{- else if and .Values.kafka.enabled .Values.externalKafka.brokers }}
    {{- required (printf (include "snippet.error-on-both-externalService-and-service-enabled-template" .) "externalKafka.brokers cannot be set if kafka.enabled is true") nil -}}
{{- else if and .Values.clickhouse.enabled .Values.externalClickhouse.host }}
    {{- required (printf (include "snippet.error-on-both-externalService-and-service-enabled-template" .) "externalClickhouse.host cannot be set if clickhouse.enabled is true") nil -}}
{{- else if and .Values.clickhouse.enabled .Values.externalClickhouse.cluster }}
    {{- required (printf (include "snippet.error-on-both-externalService-and-service-enabled-template" .) "externalClickhouse.cluster cannot be set if clickhouse.enabled is true") nil -}}
{{- end -}}
{{- end -}}

{{- define "snippet.error-on-both-externalService-and-service-enabled-template" }}


==== MISCONFIGURATION ERROR ====

Read more on how to update your values.yaml:

- %s

=========================

{{ end -}}
