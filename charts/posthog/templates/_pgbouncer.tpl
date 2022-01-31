{{/* Common pgbouncer helpers used by PostHog */}}

{{/*
Set pgbouncer host
*/}}
{{- define "posthog.pgbouncer.host" -}}
    {{- template "posthog.fullname" . }}-pgbouncer
{{- end -}}

{{/*
Set pgbouncer port
*/}}
{{- define "posthog.pgbouncer.port" -}}
    6543
{{- end -}}

{{/*
Set pgbouncer URL
*/}}
{{- define "posthog.pgbouncer.url" -}}
    postgres://{{- .Values.postgresql.postgresqlUsername -}}:{{- template "posthog.postgresql.password" . -}}@{{- template "posthog.pgbouncer.host" .  -}}:{{- template "posthog.pgbouncer.port" . -}}/{{- .Values.postgresql.postgresqlDatabase }}
{{- end -}}
