{{/* Common PostgreSQL ENV variables and helpers used by PostHog */}}

{{/* ENV used by posthog deployments for connecting to postgresql */}}
{{- define "snippet.postgresql-env" }}
- name: POSTHOG_DB_USER
  value: {{ default "posthog" .Values.postgresql.postgresqlUsername | quote }}
- name: POSTHOG_DB_NAME
  value: {{ default "posthog" .Values.postgresql.postgresqlDatabase | quote }}
- name: POSTHOG_DB_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "posthog.postgresql.secretName" . }}
      key: {{ include "posthog.postgresql.secretPasswordKey" . }}
- name: POSTHOG_POSTGRES_HOST
  value: {{ template "posthog.pgbouncer.host" . }}
- name: POSTHOG_POSTGRES_PORT
  value: {{ include "posthog.pgbouncer.port" . | quote }}
- name: USING_PGBOUNCER
  value: 'true'
{{- end }}

{{/* ENV used by migrate job for connecting to postgresql */}}
{{- define "snippet.postgresql-migrate-env" }}
- name: POSTHOG_DB_USER
  value: {{ default "posthog" .Values.postgresql.postgresqlUsername | quote }}
- name: POSTHOG_DB_NAME
  value: {{ default "posthog" .Values.postgresql.postgresqlDatabase | quote }}
- name: POSTHOG_DB_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "posthog.postgresql.secretName" . }}
      key: {{ include "posthog.postgresql.secretPasswordKey" . }}
# Connect directly to postgres (without pgbouncer) to avoid statement_timeout for longer-running queries
- name: POSTHOG_POSTGRES_HOST
  value: {{ template "posthog.postgresql.host" . }}
- name: POSTHOG_POSTGRES_PORT
  value: {{ include "posthog.postgresql.port" . | quote }}
- name: USING_PGBOUNCER
  value: 'false'
{{- end }}

{{/*
Create a default fully qualified postgresql app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "posthog.postgresql.fullname" -}}
{{- if .Values.postgresql.fullnameOverride -}}
{{- .Values.postgresql.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else if .Values.postgresql.nameOverride -}}
{{- printf "%s-%s" .Release.Name .Values.postgresql.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" (include "posthog.fullname" .) "postgresql" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Set postgres secret
*/}}
{{- define "posthog.postgresql.secretName" -}}
{{- if .Values.postgresql.existingSecret }}
{{- .Values.postgresql.existingSecret | quote -}}
{{- else if .Values.postgresql.enabled -}}
{{- template "posthog.postgresql.fullname" . -}}
{{- else -}}
{{- template "posthog.fullname" . -}}
{{- end -}}
{{- end -}}

{{/*
Set postgres secret password key
*/}}
{{- define "posthog.postgresql.secretPasswordKey" -}}
"postgresql-password"
{{- end -}}

{{/*
Set postgres host
*/}}
{{- define "posthog.postgresql.host" -}}
{{- if .Values.postgresql.enabled -}}
{{- template "posthog.postgresql.fullname" . -}}
{{- else -}}
{{- .Values.postgresql.postgresqlHost | default "" -}}
{{- end -}}
{{- end -}}

{{/*
Set postgres port
*/}}
{{- define "posthog.postgresql.port" -}}
{{- if .Values.postgresql.enabled -}}
    5432
{{- else -}}
{{- default "5432" .Values.postgresql.postgresqlPort -}}
{{- end -}}
{{- end -}}

{{/*
Set postgres password
*/}}
{{- define "posthog.postgresql.password" -}}
{{ .Values.postgresql.postgresqlPassword | default "" }}
{{- end -}}

{{/*
Set postgres password b64
*/}}
{{- define "posthog.postgresql.passwordb64" -}}
{{ .Values.postgresql.postgresqlPassword | default "" | b64enc | quote }}
{{- end -}}
