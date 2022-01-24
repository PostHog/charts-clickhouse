{{/* Checks whether removed variables are in use. */}}
{{- define "snippet.removed-vars-errors" }}
{{- if or .Values.redis.port .Values.redis.host .Values.redis.password }}
    {{- required "redis.port, redis.host and redis.password no longer valid. Read more on how to update your values.yaml: https://posthog.com/docs/self-host/deploy/upgrade-notes#upgrading-from-11xx" nil -}}
{{- end -}}
{{- end -}}
