{{/* Common Object Storage ENV variables and helpers used by PostHog */}}
{{- define "snippet.objectstorage-env" }}
{{- if .Values.minio.enabled }}
- name: OBJECT_STORAGE_HOST
  value: {{ template "posthog.objectStorage.host" . }}
- name: OBJECT_STORAGE_PORT
  value: {{ template "posthog.objectStorage.port" . }}
- name: OBJECT_STORAGE_BUCKET
  value: {{ template "posthog.objectStorage.bucket" . }}
{{- else }}
- name: OBJECT_STORAGE_HOST
  value: {{ required "externalObjectStorage.host is required if not minio.enabled" .Values.externalObjectStorage.host | quote }}
- name: OBJECT_STORAGE_PORT
  value: {{ required "externalObjectStorage.port is required if not minio.enabled" .Values.externalObjectStorage.port | quote }}
- name: OBJECT_STORAGE_BUCKET
  value: {{ required "externalObjectStorage.bucket is required if not minio.enabled" .Values.externalObjectStorage.bucket | quote }}
{{- end }}
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

{*
   ------ Object Storage ------
*}

{{/*
Return the Object Storage fullname
*/}}
{{- define "posthog.objectStorage.fullname" -}}
{{- if .Values.minio.fullnameOverride -}}
{{- .Values.minio.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else if .Values.minio.nameOverride -}}
{{- printf "%s-%s" .Release.Name .Values.minio.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" (include "posthog.fullname" .) "minio" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Return the Object Storage host
*/}}
{{- define "posthog.objectStorage.host" -}}
{{- if .Values.minio.enabled }}
    {{- printf "%s" (include "posthog.objectStorage.fullname" .) -}}
{{- else -}}
    {{- printf "%s" .Values.externalObjectStorage.host -}}
{{- end -}}
{{- end -}}

{{/*
Return the Object Storage port
*/}}
{{- define "posthog.objectStorage.port" -}}
{{- if .Values.minio.enabled }}
    "9000"
{{- else -}}
    {{- .Values.externalObjectStorage.port | quote -}}
{{- end -}}
{{- end -}}

{{/*
Return the Object Storage bucket
*/}}
{{- define "posthog.objectStorage.bucket" -}}
{{- if .Values.minio.enabled }}
    "posthog"
{{- else -}}
    {{- printf "%s" .Values.externalObjectStorage.bucket -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a secret object for Object Storage auth should be created
*/}}
{{- define "posthog.objectStorage.createSecret" -}}
{{- if (.Values.minio.enabled) (not .Values.externalRedis.existingSecret) .Values.externalRedis.password }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return the objectStorage secret name
*/}}
{{- define "posthog.objectStorage.secretName" -}}
{{- if .Values.minio.enabled }}
    {{- if .Values.minio.auth.existingSecret }}
        {{- printf "%s" .Values.minio.auth.existingSecret -}}
    {{- else -}}
        {{- printf "%s" (include "posthog.objectStorage.fullname" .) -}}
    {{- end -}}
{{- else if .Values.externalObjectStorage.existingSecret }}
    {{- printf "%s" .Values.externalObjectStorage.existingSecret -}}
{{- else -}}
    {{- printf "%s-external" (include "posthog.objectStorage.fullname" .) -}}
{{- end -}}
{{- end -}}

{* {{/*
Return the ClickHouse secret key
*/}}
{{- define "posthog.clickhouse.secretPasswordKey" -}}
{{- if .Values.externalClickhouse.existingSecret }}
    {{- required "You need to provide existingSecretPasswordKey when an existingSecret is specified in externalClickhouse" .Values.externalClickhouse.existingSecretPasswordKey | quote }}
{{- else -}}
    {{- printf "clickhouse-password" -}}
{{- end -}}
{{- end -}} *}
