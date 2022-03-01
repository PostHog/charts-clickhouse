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
