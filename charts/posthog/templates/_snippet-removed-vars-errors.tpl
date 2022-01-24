{{/* Checks whether removed variables are in use. */}}
{{- define "snippet.removed-vars-errors" }}
{{- if .Values.certManager }}
    {{- required (printf (include "snippet.removed-vars-errors-template" .) "certManager value has been renamed to cert-manager." "https://posthog.com/docs/self-host/deploy/upgrade-notes#upgrading-from-3xx") nil -}}
{{- else if .Values.beat }}
    {{- required (printf (include "snippet.removed-vars-errors-template" .) "beat deployment has been removed." "https://posthog.com/docs/self-host/deploy/upgrade-notes#upgrading-from-7xx") nil -}}
{{- else if .Values.clickhouseOperator }}
    {{- required (printf (include "snippet.removed-vars-errors-template" .) "clickhouseOperator values are no longer valid." "https://posthog.com/docs/self-host/deploy/upgrade-notes#upgrading-from-9xx") nil -}}
{{- else if or .Values.redis.port .Values.redis.host .Values.redis.password }}
    {{- required (printf (include "snippet.removed-vars-errors-template" .) "redis.port, redis.host and redis.password are no longer valid." "https://posthog.com/docs/self-host/deploy/upgrade-notes#upgrading-from-11xx") nil -}}
{{- end -}}
{{- end -}}

{{- define "snippet.removed-vars-errors-template" }}


==== BREAKING CHANGE ====

%s

Read more on how to update your values.yaml:
%s

=========================

{{ end -}}
