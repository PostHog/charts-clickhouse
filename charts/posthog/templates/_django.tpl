{{/* Common django definitions */}}

{{- define "posthog.djangoSecretKey.existingSecret" }}
  {{- if .Values.djangoSecretKey.existingSecret -}}
    {{- .Values.djangoSecretKey.existingSecret -}}
  {{- else -}}
    {{- template "posthog.fullname" . -}}
  {{- end -}}
{{- end }}

{{- define "snippet.django-env" }}
- name: SECRET_KEY
  valueFrom:
    secretKeyRef:
      name: {{ template "posthog.djangoSecretKey.existingSecret" . }}
      key: {{ .Values.djangoSecretKey.existingSecretKey }}
{{- end }}
