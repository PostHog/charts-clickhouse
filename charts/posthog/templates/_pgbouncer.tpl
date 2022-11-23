{{/* Common PgBouncer helpers used by PostHog */}}

{{/*
Set PgBouncer FQDN
*/}}
{{- define "posthog.pgbouncer.fqdn" -}}
    {{- $fullname := include "posthog.fullname" . -}}
    {{- $serviceName := printf "%s-pgbouncer" $fullname -}}
    {{- $releaseNamespace := .Release.Namespace -}}
    {{- $clusterDomain := .Values.clusterDomain -}}
    {{- printf "%s.%s.svc.%s" $serviceName $releaseNamespace $clusterDomain -}}
{{- end -}}

{{/*
Set PgBouncer host
*/}}
{{- define "posthog.pgbouncer.host" -}}
    {{- template "posthog.fullname" . }}-pgbouncer
{{- end -}}

{{/*
Set PgBouncer port
*/}}
{{- define "posthog.pgbouncer.port" -}}
    6543
{{- end -}}
