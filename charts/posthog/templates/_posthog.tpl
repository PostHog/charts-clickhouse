{{/* Common PostHog definitions */}}

{{- define "posthog.posthogSecretKey.existingSecret" }}
  {{- if .Values.posthogSecretKey.existingSecret -}}
    {{- .Values.posthogSecretKey.existingSecret -}}
  {{- else -}}
    {{- template "posthog.fullname" . -}}
  {{- end -}}
{{- end }}

{{- define "snippet.posthog-env" }}
- name: SECRET_KEY
  valueFrom:
    secretKeyRef:
      name: {{ template "posthog.posthogSecretKey.existingSecret" . }}
      key: {{ .Values.posthogSecretKey.existingSecretKey }}
- name: SITE_URL
  value: {{ template "posthog.site.url" . }}
- name: SENTRY_DSN
  value: {{ .Values.sentryDSN | quote }}
- name: DEPLOYMENT
  value: {{ template "posthog.deploymentEnv" . }}
{{- end }}
