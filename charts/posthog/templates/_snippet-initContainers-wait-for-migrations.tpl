{{/* Common initContainers-wait-for-migrations definition */}}
{{- define "_snippet-initContainers-wait-for-migrations" }}
- name: wait-for-migrations
  image: {{ include "posthog.image.fullPath" . }}
  command:
    - /bin/sh
    - -c
    - |
        set -e
        until (bin/migrate-check);
        do
            echo "Waiting for database migrations to be completed"; sleep 1;
        done
  env:

  # PostgreSQL configuration
  {{- include "snippet.postgresql-env" . | nindent 2 }}

  # Redis env variables
  {{- include "snippet.redis-env" . | indent 2 }}

  # ClickHouse env variables
  {{- include "snippet.clickhouse-env" . | nindent 2 }}

  # Django specific settings
  - name: SECRET_KEY
    valueFrom:
      secretKeyRef:
        name: {{ template "posthog.fullname" . }}
        key: posthog-secret

{{- end }}
