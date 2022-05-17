{*
   ------ Object Storage ------
*}

{{/* Return true if the Object Storage functionality is enabled */}}
{{- define "posthog.objectStorage.enabled" -}}
{{- if (.Values.minio.enabled) or (.Values.externalObjectStorage.host) }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/* Return the Object Storage fullname */}}
{{- define "posthog.objectStorage.fullname" -}}
{{- if .Values.minio.fullnameOverride -}}
{{- .Values.minio.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else if .Values.minio.nameOverride -}}
{{- printf "%s-%s" .Release.Name .Values.minio.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" (include "posthog.fullname" .) "minio" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/* Return the Object Storage host */}}
{{- define "posthog.objectStorage.host" -}}
{{- if .Values.minio.enabled }}
    {{- printf "%s" (include "posthog.objectStorage.fullname" .) -}}
{{- else if .Values.externalObjectStorage.host -}}
    {{- printf "%s" .Values.externalObjectStorage.host -}}
{{- end -}}
{{- end -}}

{{/* Return the Object Storage port */}}
{{- define "posthog.objectStorage.port" -}}
{{- if .Values.minio.enabled }}
    "9000"
{{- else if .Values.externalObjectStorage.port -}}
    {{- .Values.externalObjectStorage.port | quote -}}
{{- end -}}
{{- end -}}

{{/* Return the Object Storage bucket */}}
{{- define "posthog.objectStorage.bucket" -}}
{{- if .Values.minio.enabled }}
    "posthog"
{{- else if .Values.externalObjectStorage.bucket -}}
    {{- printf "%s" .Values.externalObjectStorage.bucket -}}
{{- end -}}
{{- end -}}

{{/* Return the objectStorage secret name */}}
{{- define "posthog.objectStorage.secretName" -}}
{{- if .Values.minio.enabled }}
    {{- if .Values.minio.auth.existingSecret }}
        {{- printf "%s" .Values.minio.auth.existingSecret -}}
    {{- else -}}
        {{- printf "%s" (include "posthog.objectStorage.fullname" .) -}}
    {{- end -}}
{{- else if .Values.externalObjectStorage.existingSecret }}
    {{- printf "%s" .Values.externalObjectStorage.existingSecret -}}
{{- end -}}
{{- end -}}

{{/* Common Object Storage ENV variables and helpers used by PostHog */}}
{{- define "snippet.objectstorage-env" }}
{{- if .Values.minio.enabled }}
- name: OBJECT_STORAGE_HOST
  value: {{ template "posthog.objectStorage.host" . }}
- name: OBJECT_STORAGE_PORT
  value: {{ template "posthog.objectStorage.port" . }}
- name: OBJECT_STORAGE_BUCKET
  value: {{ template "posthog.objectStorage.bucket" . }}
{{- else if .Values.externalObjectStorage.host -}}
- name: OBJECT_STORAGE_HOST
  value: {{ template ".Values.externalObjectStorage.host" . }}
- name: OBJECT_STORAGE_PORT
  value: {{ template  ".Values.externalObjectStorage.port" . }}
- name: OBJECT_STORAGE_BUCKET
  value: {{ template ".Values.externalObjectStorage.bucket" . }}
{{- end }}
{{- if "posthog.objectStorage.secretName" }}
- name: OBJECT_STORAGE_ACCESS_KEY_ID
  valueFrom:
    secretKeyRef:
      name: {{ include "posthog.objectStorage.secretName" . }}
      key: 'root-user'
- name: OBJECT_STORAGE_SECRET_ACCESS_KEY
  valueFrom:
    secretKeyRef:
      name: {{ include "posthog.objectStorage.secretName" . }}
      key: 'root-password'
{{- end }}
{{- end }}
