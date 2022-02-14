{{/* Common email ENV variables and helpers used by PostHog */}}

{{/* ENV used by posthog deployments for connecting to smtp */}}
{{- define "snippet.email-env" }}
- name: EMAIL_HOST
  value: {{ default "" .Values.email.host | quote }}
- name: EMAIL_PORT
  value: {{ default "" .Values.email.port | quote }}
- name: EMAIL_HOST_USER
  value: {{ default "" .Values.email.user | quote }}
- name: EMAIL_HOST_PASSWORD
  valueFrom:
    secretKeyRef:
    {{- if .Values.email.existingSecret }}
      name: {{ .Values.email.existingSecret }}
    {{- else }}
      name: {{ template "posthog.fullname" . }}
    {{- end }}
      key: {{ default "smtp-password" .Values.email.existingSecretKey | quote }}
- name: EMAIL_USE_TLS
  value: {{ default "false" .Values.email.use_tls | quote }}
- name: EMAIL_USE_SSL
  value: {{ default "false" .Values.email.use_ssl | quote }}
- name: DEFAULT_FROM_EMAIL
  value: {{ .Values.email.from_email | quote }}
{{- end }}
