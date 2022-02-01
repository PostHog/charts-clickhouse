{{/* Common PostgreSQL ENV variables and helpers used by PostHog */}}

{{/* ENV used by posthog deployments for connecting to postgresql */}}
{{- define "snippet.postgresql-env" }}
- name: POSTHOG_POSTGRES_HOST
  value: {{ template "posthog.pgbouncer.host" . }}
- name: POSTHOG_POSTGRES_PORT
  value: {{ include "posthog.pgbouncer.port" . | quote }}
- name: POSTHOG_DB_USER
  value: {{ include "posthog.postgresql.username" . }}
- name: POSTHOG_DB_NAME
  value: {{ include "posthog.postgresql.database" . }}
- name: POSTHOG_DB_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "posthog.postgresql.secretName" . }}
      key: {{ include "posthog.postgresql.secretPasswordKey" . }}
- name: USING_PGBOUNCER
  value: 'true'
{{- end }}

{{/* ENV used by migrate job for connecting to postgresql */}}
{{- define "snippet.postgresql-migrate-env" }}
# Connect directly to postgres (without pgbouncer) to avoid statement_timeout for longer-running queries
- name: POSTHOG_POSTGRES_HOST
  value: {{ template "posthog.postgresql.host" . }}
- name: POSTHOG_POSTGRES_PORT
  value: {{ include "posthog.postgresql.port" . | quote }}
- name: POSTHOG_DB_USER
  value: {{ include "posthog.postgresql.username" . }}
- name: POSTHOG_DB_NAME
  value: {{ include "posthog.postgresql.database" . }}
- name: POSTHOG_DB_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "posthog.postgresql.secretName" . }}
      key: {{ include "posthog.postgresql.secretPasswordKey" . }}
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
{{- if and .Values.postgresql.enabled .Values.postgresql.existingSecret }}
{{- .Values.postgresql.existingSecret | quote -}}
{{- else if and (not .Values.postgresql.enabled) .Values.externalPostgresql.existingSecret }}
{{- .Values.externalPostgresql.existingSecret | quote -}}
{{- else -}}

{{- if and .Values.postgresql.enabled (not .Values.postgresql.postgresqlPassword) -}}
{{ fail "postgresql.password or postgresql.existingSecret is required" }}
{{- else if and (not .Values.postgresql.enabled) (not .Values.externalPostgresql.postgresqlPassword )}}
{{ required "externalPostgresql.password or externalPostgresql.existingSecret is required" nil }}
{{- end -}}

{{- template "posthog.fullname" . -}}
{{- end -}}
{{- end -}}

{{/*
Set postgres secret password key
*/}}
{{- define "posthog.postgresql.secretPasswordKey" -}}
{{- if .Values.postgresql.enabled -}}
"postgresql-password"
{{- else -}}
{{- .Values.externalPostgresql.existingSecretPasswordKey | quote -}}
{{- end -}}
{{- end -}}

{{/*
Set postgres host
*/}}
{{- define "posthog.postgresql.host" -}}
{{- if .Values.postgresql.enabled -}}
{{- template "posthog.postgresql.fullname" . -}}
{{- else -}}
{{- required "externalPostgresql.postgresqlHost is required if not postgresql.enabled" .Values.externalPostgresql.postgresqlHost | quote }}
{{- end -}}
{{- end -}}

{{/*
Set postgres port
*/}}
{{- define "posthog.postgresql.port" -}}
{{- if .Values.postgresql.enabled -}}
5432
{{- else -}}
{{- .Values.externalPostgresql.postgresqlPort -}}
{{- end -}}
{{- end -}}

{{/*
Set postgres username
*/}}
{{- define "posthog.postgresql.username" -}}
{{- if .Values.postgresql.enabled -}}
"postgres"
{{- else -}}
{{- .Values.externalPostgresql.postgresqlUsername | quote -}}
{{- end -}}
{{- end -}}

{{/*
Set postgres database
*/}}
{{- define "posthog.postgresql.database" -}}
{{- if .Values.postgresql.enabled -}}
{{- .Values.postgresql.postgresqlDatabase | quote -}}
{{- else -}}
{{- .Values.externalPostgresql.postgresqlDatabase | quote -}}
{{- end -}}
{{- end -}}

{{/*
Set postgres password. Don't use this outside of secrets!
*/}}
{{- define "posthog.postgresql.password" -}}
{{- if and .Values.postgresql.enabled (not .Values.postgresql.existingSecret) -}}
{{- .Values.postgresql.postgresqlPassword -}}
{{- else if and (not .Values.postgresql.enabled) (not .Values.externalPostgresql.existingSecret) -}}
{{- .Values.externalPostgresql.postgresqlPassword -}}
{{- end -}}
{{- end -}}

{{/*
Set postgres secret created in secrets.yaml
*/}}
{{- define "posthog.postgresql.createdSecret" -}}
{{- if not (or .Values.postgresql.existingSecret .Values.externalPostgresql.existingSecret) -}}
postgresql-password: {{ include "posthog.postgresql.password" . | default "" | b64enc | quote -}}
{{- end -}}
{{- end -}}
