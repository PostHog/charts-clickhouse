{{/* Common initContainers-wait-for-migrations definition */}}
{{- define "_snippet-initContainers-wait-for-migrations" }}
- name: wait-for-migrations
  image: {{ include "posthog.image.fullPath" . }}
  command:
    - /bin/sh
    - -c
    - >
        until (python manage.py migrate --check);
        do
            echo "Waiting for database migrations to be completed"; sleep 1;
        done
  env:

  # PostgreSQL configuration
  - name: POSTHOG_POSTGRES_HOST
    value: {{ template "posthog.pgbouncer.host" . }}
  - name: POSTHOG_POSTGRES_PORT
    value: {{ include "posthog.pgbouncer.port" . | quote }}
  - name: POSTHOG_DB_NAME
    value: {{ default "posthog" .Values.postgresql.postgresqlDatabase | quote }}
  - name: POSTHOG_DB_USER
    value: {{ default "posthog" .Values.postgresql.postgresqlUsername | quote }}
  - name: POSTHOG_DB_PASSWORD
    valueFrom:
      secretKeyRef:
      {{- if .Values.postgresql.existingSecret }}
        name: {{ .Values.postgresql.existingSecret }}
      {{- else }}
        name: {{ template "posthog.postgresql.secret" . }}
      {{- end }}
        key: {{ template "posthog.postgresql.secretKey" . }}

  # Redis configuration
  - name: POSTHOG_REDIS_HOST
    value: {{ template "posthog.redis.host" . }}
  - name: POSTHOG_REDIS_PORT
    value: {{ include "posthog.redis.port" . | quote }}
  {{- if or (.Values.redis.enabled) (.Values.redis.password) }}
  - name: POSTHOG_REDIS_PASSWORD
    value: {{ .Values.redis.password | quote }}
  {{- end }}

  # Django specific settings
  - name: SECRET_KEY
    valueFrom:
      secretKeyRef:
        name: {{ template "posthog.fullname" . }}
        key: posthog-secret

{{- end }}
