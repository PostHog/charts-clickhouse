{{/* Common Redis ENV variables */}}
{{- define "snippet.redis-env" }}

- name: POSTHOG_REDIS_HOST
  value: {{ include "posthog.redis.host" . }}

- name: POSTHOG_REDIS_PORT
  value: {{ include "posthog.redis.port" . }}

{{- if (include "posthog.redis.auth.enabled" .) }}
- name: POSTHOG_REDIS_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "posthog.redis.secretName" . }}
      key: {{ include "posthog.redis.secretPasswordKey" . }}
{{- end }}

{{- end }}
