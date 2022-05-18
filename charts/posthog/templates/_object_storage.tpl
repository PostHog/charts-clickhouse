{*
   ------ Object Storage ------
*}

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

{{/* Common Object Storage ENV variables and helpers used by PostHog */}}
{{- define "snippet.objectstorage-env" }}

{{/* MINIO */}}
{{- if .Values.minio.enabled }}
- name: OBJECT_STORAGE_HOST
  value: {{ include "posthog.objectStorage.fullname" . }}
- name: OBJECT_STORAGE_PORT
  value: {{ .Values.minio.service.ports.api | quote }}
- name: OBJECT_STORAGE_BUCKET
  value: "posthog"
{{/* MINIO - with secret */}}
{{- if .Values.minio.auth.existingSecret }}
- name: OBJECT_STORAGE_ACCESS_KEY_ID
  valueFrom:
    secretKeyRef:
      name: {{ .Values.minio.auth.existingSecret }}
      key: 'root-user'
- name: OBJECT_STORAGE_SECRET_ACCESS_KEY
  valueFrom:
    secretKeyRef:
      name: {{ .Values.minio.auth.existingSecret }}
      key: 'root-password'
{{- else -}}
{{/* MINIO - with login */}}
- name: OBJECT_STORAGE_ACCESS_KEY_ID
  value: {{ .Values.minio.auth.rootUser }}
- name: OBJECT_STORAGE_SECRET_ACCESS_KEY
  value: {{ .Values.minio.auth.rootPassword }}
{{- end -}}

{{/* External Object Storage */}}
{{- else if .Values.externalObjectStorage.host }}
- name: OBJECT_STORAGE_HOST
  value: {{ .Values.externalObjectStorage.host }}
- name: OBJECT_STORAGE_PORT
  value: {{ .Values.externalObjectStorage.port | quote }}
- name: OBJECT_STORAGE_BUCKET
  value: {{ .Values.externalObjectStorage.bucket }}
- name: OBJECT_STORAGE_ACCESS_KEY_ID
  valueFrom:
    secretKeyRef:
      name: {{ .Values.externalObjectStorage.existingSecret }}
      key: 'root-user'
- name: OBJECT_STORAGE_SECRET_ACCESS_KEY
  valueFrom:
    secretKeyRef:
      name: {{ .Values.externalObjectStorage.existingSecret }}
      key: 'root-password'
{{- end }}
{{- end }}
