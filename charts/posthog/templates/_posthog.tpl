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
{{- end }}
