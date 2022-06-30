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
{{ if .Values.sentryDSN }}
- name: SENTRY_DSN
  value: {{ .Values.sentryDSN | quote }}
{{ end }}
- name: DEPLOYMENT
  value: {{ template "posthog.deploymentEnv" . }}
- name: CAPTURE_INTERNAL_METRICS
  value: {{ .Values.web.internalMetrics.capture| quote }}
- name: HELM_INSTALL_INFO
  value: {{ template "posthog.helmInstallInfo" . }}
{{- end }}
