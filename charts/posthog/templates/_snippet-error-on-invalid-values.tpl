{{/* Checks whether invalid values are set */}}
{{- define "snippet.error-on-invalid-values" }}
  {{- if and .Values.postgresql.enabled .Values.externalPostgresql.postgresqlHost }}
    {{- required (printf (include "snippet.error-on-invalid-values-template" .)
      "externalPostgresql.postgresqlHost cannot be set if postgresql.enabled is true" ""
    ) nil -}}

  {{- else if and .Values.redis.enabled .Values.externalRedis.host }}
    {{- required (printf (include "snippet.error-on-invalid-values-template" .)
      "externalRedis.host cannot be set if redis.enabled is true" ""
    ) nil -}}

  {{- else if and .Values.kafka.enabled .Values.externalKafka.brokers }}
    {{- required (printf (include "snippet.error-on-invalid-values-template" .)
      "externalKafka.brokers cannot be set if kafka.enabled is true" ""
    ) nil -}}

  {{- else if and .Values.clickhouse.enabled .Values.externalClickhouse.host }}
    {{- required (printf (include "snippet.error-on-invalid-values-template" .)
      "externalClickhouse.host cannot be set if clickhouse.enabled is true" ""
    ) nil -}}

  {{- else if and .Values.clickhouse.enabled .Values.externalClickhouse.cluster }}
    {{- required (printf (include "snippet.error-on-invalid-values-template" .)
      "externalClickhouse.cluster cannot be set if clickhouse.enabled is true" ""
    ) nil -}}

  {{- else if .Values.certManager }}
    {{- required (printf (include "snippet.error-on-invalid-values-template" .)
      "certManager value has been renamed to cert-manager"
      "https://posthog.com/docs/self-host/deploy/upgrade-notes#upgrading-from-3xx"
    ) nil -}}

  {{- else if .Values.beat }}
    {{- required (printf (include "snippet.error-on-invalid-values-template" .)
      "beat deployment has been removed"
      "https://posthog.com/docs/self-host/deploy/upgrade-notes#upgrading-from-7xx"
    ) nil -}}

  {{- else if .Values.clickhouseOperator }}
    {{- required (printf (include "snippet.error-on-invalid-values-template" .)
      "clickhouseOperator values are no longer valid"
      "https://posthog.com/docs/self-host/deploy/upgrade-notes#upgrading-from-9xx"
    ) nil -}}

  {{- else if or .Values.redis.port .Values.redis.host .Values.redis.password }}
    {{- required (printf (include "snippet.error-on-invalid-values-template" .)
      "redis.port, redis.host and redis.password are no longer valid"
      "https://posthog.com/docs/self-host/deploy/upgrade-notes#upgrading-from-11xx"
    ) nil -}}

  {{- else if .Values.clickhouse.host }}
    {{- required (printf (include "snippet.error-on-invalid-values-template" .)
      "clickhouse.host has been moved to externalClickhouse.host"
      "https://posthog.com/docs/self-host/deploy/upgrade-notes#upgrading-from-13xx"
    ) nil -}}

  {{- else if .Values.clickhouse.replication }}
    {{- required (printf (include "snippet.error-on-invalid-values-template" .)
      "clickhouse.replication has been removed"
      "https://posthog.com/docs/self-host/deploy/upgrade-notes#upgrading-from-12xx"
    ) nil -}}

  {{- else if .Values.postgresql.postgresqlHost }}
    {{- required (printf (include "snippet.error-on-invalid-values-template" .)
      "postgresql.postgresqlHost has been moved to externalPostgresql.postgresqlHost"
      "https://posthog.com/docs/self-host/deploy/upgrade-notes#upgrading-from-13xx"
    ) nil -}}

  {{- else if .Values.postgresql.postgresqlPort }}
    {{- required (printf (include "snippet.error-on-invalid-values-template" .)
      "postgresql.postgresqlPort has been moved to externalPostgresql.postgresqlPort"
      "https://posthog.com/docs/self-host/deploy/upgrade-notes#upgrading-from-13xx"
    ) nil -}}

  {{- else if .Values.postgresql.postgresqlUsername }}
    {{- if ne .Values.postgresql.postgresqlUsername "postgres" }}
      {{- required (printf (include "snippet.error-on-invalid-values-template" .)
        "postgresql.postgresqlUsername has been removed"
        "https://posthog.com/docs/self-host/deploy/upgrade-notes#upgrading-from-13xx"
      ) nil -}}
    {{- end -}}

    {{- if .Values.clickhouse.useNodeSelector }}
      {{- required (printf (include "snippet.error-on-invalid-values-template" .)
        "clickhouse.useNodeSelector has been removed"
        "please use the clickhouse.nodeSelector variable instead"
      ) nil -}}
    {{- end -}}

    {{- if and .Values.pluginsAsync.enabled (not .Values.plugins.enabled) }}
      {{- required (printf (include "snippet.error-on-invalid-values-template" .)
        "pluginsAsync.enabled cannot be set if plugins.enabled is false" ""
      ) nil -}}
    {{- end -}}
  {{- end -}}
{{- end -}}

{{- define "snippet.error-on-invalid-values-template" }}

==== INVALID VALUES ====

Read more on how to update your values.yaml:

- %s
  %s

=========================
{{ end -}}
