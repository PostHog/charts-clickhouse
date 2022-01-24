{{/* Checks whether removed variables are in use. */}}
{{- define "snippet.removed-vars-errors" }}
{{- if or .Values.redis.port .Values.redis.host .Values.redis.password }}
    {{- required "\n\n==== BREAKING CHANGE ====\n\nredis.port, redis.host and redis.password are no longer valid.\n\nRead more on how to update your values.yaml: https://posthog.com/docs/self-host/deploy/upgrade-notes#upgrading-from-11xx\n\n=========================\n\n" nil }}
{{- end -}}
{{- end -}}
