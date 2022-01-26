{{/* Common ClickHouse ENV variables used by PostHog */}}
{{- define "snippet.clickhouse-env" }}
- name: CLICKHOUSE_DATABASE
  value: {{ .Values.clickhouse.database | quote }}
- name: CLICKHOUSE_HOST
  {{- if .Values.clickhouse.host }}
  value: {{ .Values.clickhouse.host | quote }}
  {{- else }}
  value: {{ template "posthog.clickhouse.fullname" . }}
  {{- end }}
- name: CLICKHOUSE_USER
  value: {{ .Values.clickhouse.user | quote }}
- name: CLICKHOUSE_PASSWORD
  value: {{ .Values.clickhouse.password | quote }}
- name: CLICKHOUSE_SECURE
  value: {{ .Values.clickhouse.secure | quote }}
- name: CLICKHOUSE_VERIFY
  value: {{ .Values.clickhouse.verify | quote }}
{{- end }}
