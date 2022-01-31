{{/* Common PostgreSQL and pgbouncer ENV variables and helpers used by PostHog */}}
{{- define "snippet.postgresql-env" }}
- name: POSTHOG_DB_USER
  value: {{ default "posthog" .Values.postgresql.postgresqlUsername | quote }}
- name: POSTHOG_DB_NAME
  value: {{ default "posthog" .Values.postgresql.postgresqlDatabase | quote }}
- name: POSTHOG_DB_PASSWORD
  valueFrom:
    secretKeyRef:
      {{- if .Values.postgresql.existingSecret }}
      name: {{ .Values.postgresql.existingSecret }}
      {{- else }}
      name: {{ template "posthog.postgresql.secret" . }}
      {{- end }}
      key: {{ template "posthog.postgresql.secretKey" . }}
- name: POSTHOG_POSTGRES_HOST
  value: {{ template "posthog.pgbouncer.host" . }}
- name: POSTHOG_POSTGRES_PORT
  value: {{ include "posthog.pgbouncer.port" . | quote }}
- name: USING_PGBOUNCER
  value: 'true'
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
{{- define "posthog.postgresql.secret" -}}
{{- if .Values.postgresql.enabled -}}
{{- template "posthog.postgresql.fullname" . -}}
{{- else -}}
{{- template "posthog.fullname" . -}}
{{- end -}}
{{- end -}}

{{/*
Set postgres secretKey
*/}}
{{- define "posthog.postgresql.secretKey" -}}
{{- if .Values.postgresql.enabled -}}
"postgresql-password"
{{- else -}}
{{- default "postgresql-password" .Values.postgresql.existingSecretKey | quote -}}
{{- end -}}
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

{{/*
Set postgres URL
*/}}
{{- define "posthog.postgresql.url" -}}
    postgres://{{- .Values.postgresql.postgresqlUsername -}}:{{- template "posthog.postgresql.password" . -}}@{{- template "posthog.postgresql.host" .  -}}:{{- template "posthog.postgresql.port" . -}}/{{- .Values.postgresql.postgresqlDatabase }}
{{- end -}}

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
