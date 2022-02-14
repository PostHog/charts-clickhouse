{{/* Checks whether removed variables are in use. */}}
{{- define "snippet.error-on-removed-values" }}
{{- if .Values.certManager }}
    {{- required (printf (include "snippet.error-on-removed-values-template" .) "certManager value has been renamed to cert-manager." "https://posthog.com/docs/self-host/deploy/upgrade-notes#upgrading-from-3xx") nil -}}
{{- else if .Values.beat }}
    {{- required (printf (include "snippet.error-on-removed-values-template" .) "beat deployment has been removed." "https://posthog.com/docs/self-host/deploy/upgrade-notes#upgrading-from-7xx") nil -}}
{{- else if .Values.clickhouseOperator }}
    {{- required (printf (include "snippet.error-on-removed-values-template" .) "clickhouseOperator values are no longer valid." "https://posthog.com/docs/self-host/deploy/upgrade-notes#upgrading-from-9xx") nil -}}
{{- else if or .Values.redis.port .Values.redis.host .Values.redis.password }}
    {{- required (printf (include "snippet.error-on-removed-values-template" .) "redis.port, redis.host and redis.password are no longer valid." "https://posthog.com/docs/self-host/deploy/upgrade-notes#upgrading-from-11xx") nil -}}
{{- else if .Values.clickhouse.host }}
    {{- required (printf (include "snippet.error-on-removed-values-template" .) "clickhouse.host has been moved to externalClickhouse.host" "https://posthog.com/docs/self-host/deploy/upgrade-notes#upgrading-from-13xx") nil -}}
{{- else if .Values.clickhouse.replication }}
    {{- required (printf (include "snippet.error-on-removed-values-template" .) "clickhouse.replication has been removed" "https://posthog.com/docs/self-host/deploy/upgrade-notes#upgrading-from-12xx") nil -}}
{{- else if .Values.postgresql.postgresqlHost }}
    {{- required (printf (include "snippet.error-on-removed-values-template" .) "postgresql.postgresqlHost has been moved to externalPostgresql.postgresqlHost" "https://posthog.com/docs/self-host/deploy/upgrade-notes#upgrading-from-13xx") nil -}}
{{- else if .Values.postgresql.postgresqlPort }}
    {{- required (printf (include "snippet.error-on-removed-values-template" .) "postgresql.postgresqlPort has been moved to externalPostgresql.postgresqlPort" "https://posthog.com/docs/self-host/deploy/upgrade-notes#upgrading-from-13xx") nil -}}
{{- else if .Values.postgresql.postgresqlUsername }}
{{- if ne .Values.postgresql.postgresqlUsername "postgres" }}
    {{- required (printf (include "snippet.error-on-removed-values-template" .) "postgresql.postgresqlUsername has been removed" "https://posthog.com/docs/self-host/deploy/upgrade-notes#upgrading-from-13xx") nil -}}
{{- end -}}
{{- if .Values.clickhouse.useNodeSelector }}
    {{- required (printf (include "snippet.error-on-removed-values-template" .) "clickhouse.useNodeSelector has been removed." "please use the clickhouse.nodeSelector variable instead") nil -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "snippet.error-on-removed-values-template" }}


==== BREAKING CHANGE ====

%s

Read more on how to update your values.yaml:
%s

=========================

{{ end -}}
