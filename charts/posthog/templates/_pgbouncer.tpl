{{/* Common PgBouncer helpers used by PostHog */}}

{{/*
Set PgBouncer FQDN
*/}}
{{- define "posthog.pgbouncer.fqdn" -}}
    {{- $fullname := include "posthog.fullname" . -}}
    {{- $serviceName := printf "%s-pgbouncer" $fullname -}}
    {{- $releaseNamespace := .Release.Namespace -}}
    {{- $clusterDomain := .Values.clusterDomain -}}
    {{- printf "%s.%s.svc.%s." $serviceName $releaseNamespace $clusterDomain -}}
{{- end -}}

{{/*
Set PgBouncer host
*/}}
{{- define "posthog.pgbouncer.host" -}}
    {{- default (printf "%s-pgbouncer" (include "posthog.fullname" .)) .Values.pgbouncer.fqdn -}}
{{- end -}}

{{/*
Set PgBouncer port
*/}}
{{- define "posthog.pgbouncer.port" -}}
    6543
{{- end -}}

{{/*
Set Read PgBouncer host
*/}}
{{- define "posthog.pgbouncer-read.host" -}}
    {{- default (printf "%s-pgbouncer-read" (include "posthog.fullname" .)) .Values.pgbouncerRead.fqdn -}}
{{- end -}}

{{/*
Set PgBouncer port
*/}}
{{- define "posthog.pgbouncer-read.port" -}}
    6543
{{- end -}}
