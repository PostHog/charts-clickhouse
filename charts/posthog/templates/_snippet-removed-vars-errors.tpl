{{/* Checks whether removed variables are in use. */}}
{{- define "snippet.removed-vars-errors" }}
{{- if or .Values.beat }}
    {{- required (printf (include "snipper.removed-vars-errors-template" .) "beat deployment has been removed." "https://posthog.com/docs/self-host/deploy/upgrade-notes#upgrading-from-7xx") nil -}}
{{- else if or .Values.clickhouseOperator }}
    {{- required (printf (include "snipper.removed-vars-errors-template" .) "clickhouseOperator values are no longer valid." "https://posthog.com/docs/self-host/deploy/upgrade-notes#upgrading-from-9xx") nil -}}
{{- else if or .Values.redis.port .Values.redis.host .Values.redis.password }}
    {{- required (printf (include "snipper.removed-vars-errors-template" .) "redis.port, redis.host and redis.password are no longer valid." "https://posthog.com/docs/self-host/deploy/upgrade-notes#upgrading-from-11xx") nil -}}
{{- end -}}
{{- end -}}

{{- define "snipper.removed-vars-errors-template" }}


==== BREAKING CHANGE ====

%s

Read more on how to update your values.yaml:
%s

=========================

{{ end -}}
