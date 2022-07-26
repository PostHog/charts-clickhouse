{{/* Common initContainers-wait-for-migrations definition */}}
{{- define "_snippet-initContainers-wait-for-migrations" }}
- name: wait-for-migrations
  image: {{ include "posthog.image.fullPath" . }}
  imagePullPolicy: {{ .Values.busybox.pullPolicy }}
  command:
    - /bin/sh
    - -c
    - >
        until (python manage.py migrate --check);
        do
            echo "Waiting for PostgreSQL database migrations to be completed"; sleep 1;
        done

        until (python manage.py migrate_clickhouse --check);
        do
            echo "Waiting for ClickHouse database migrations to be completed";
            sleep 1;
        done
  env:

  # PostgreSQL configuration
  {{- include "snippet.postgresql-env" . | nindent 2 }}

  # Redis env variables
  {{- include "snippet.redis-env" . | indent 2 }}

  # ClickHouse env variables
  {{- include "snippet.clickhouse-env" . | nindent 2 }}

  # PostHog app settings
  {{- include "snippet.posthog-env" . | nindent 2 }}
  {{- include "snippet.posthog-sentry-env" . | nindent 2 }}

  # Global ENV variables
  {{- if .Values.env }}
  {{ toYaml .Values.env | nindent 2 }}
  {{- end }}

{{- end }}
