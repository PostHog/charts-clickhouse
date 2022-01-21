{{/* vim: set filetype=mustache: */}}

{{/*
Expand the name of the chart.
*/}}
{{- define "posthog.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "posthog.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "posthog.postgresql.fullname" -}}
{{- if .Values.postgresql.fullnameOverride -}}
{{- .Values.postgresql.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else if .Values.postgresql.nameOverride -}}
{{- printf "%s-%s" .Release.Name .Values.postgresql.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" (include "posthog.fullname" .) "postgresql" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{- define "posthog.zookeeper.fullname" -}}
{{- if .Values.zookeeper.fullnameOverride -}}
{{- .Values.zookeeper.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else if .Values.zookeeper.nameOverride -}}
{{- printf "%s-%s" .Release.Name .Values.zookeeper.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" (include "posthog.fullname" .) "zookeeper" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Set the posthog image
*/}}
{{- define "posthog.image.fullPath" -}}
{{ if .Values.image.sha -}}
"{{ .Values.image.repository }}@{{ .Values.image.sha }}"
{{- else if .Values.image.tag -}}
"{{ .Values.image.repository }}:{{ .Values.image.tag }}"
{{- else -}}
"{{ .Values.image.repository }}{{ .Values.image.default }}"
{{- end -}}
{{- end -}}

{{/*
Set postgres secret
*/}}
{{- define "posthog.postgresql.secret" -}}
{{- if .Values.postgresql.enabled -}}
{{- template "posthog.postgresql.fullname" . -}}
{{- else -}}
{{- template "posthog.fullname" . -}}
{{- end -}}
{{- end -}}

{{/*
Set postgres secretKey
*/}}
{{- define "posthog.postgresql.secretKey" -}}
{{- if .Values.postgresql.enabled -}}
"postgresql-password"
{{- else -}}
{{- default "postgresql-password" .Values.postgresql.existingSecretKey | quote -}}
{{- end -}}
{{- end -}}

{{/*
Set postgres host
*/}}
{{- define "posthog.postgresql.host" -}}
{{- if .Values.postgresql.enabled -}}
{{- template "posthog.postgresql.fullname" . -}}
{{- else -}}
{{- .Values.postgresql.postgresqlHost | default "" -}}
{{- end -}}
{{- end -}}

{{/*
Set postgres port
*/}}
{{- define "posthog.postgresql.port" -}}
{{- if .Values.postgresql.enabled -}}
    5432
{{- else -}}
{{- default "5432" .Values.postgresql.postgresqlPort -}}
{{- end -}}
{{- end -}}

{{/*
Set postgres password
*/}}
{{- define "posthog.postgresql.password" -}}
{{ .Values.postgresql.postgresqlPassword | default "" }}
{{- end -}}

{{/*
Set postgres password b64
*/}}
{{- define "posthog.postgresql.passwordb64" -}}
{{ .Values.postgresql.postgresqlPassword | default "" | b64enc | quote }}
{{- end -}}

{{/*
Set postgres URL
*/}}
{{- define "posthog.postgresql.url" -}}
    postgres://{{- .Values.postgresql.postgresqlUsername -}}:{{- template "posthog.postgresql.password" . -}}@{{- template "posthog.postgresql.host" .  -}}:{{- template "posthog.postgresql.port" . -}}/{{- .Values.postgresql.postgresqlDatabase }}
{{- end -}}

{{/*
Set zookeeper host
*/}}
{{- define "posthog.zookeeper.host" -}}
{{- include "posthog.zookeeper.fullname" . -}}
{{- end -}}

{{/*
Set zookeeper port
*/}}
{{- define "posthog.zookeeper.port" -}}
    2181
{{- end -}}

{{/*
Set pgbouncer host
*/}}
{{- define "posthog.pgbouncer.host" -}}
    {{- template "posthog.fullname" . }}-pgbouncer
{{- end -}}

{{/*
Set pgbouncer port
*/}}
{{- define "posthog.pgbouncer.port" -}}
    6543
{{- end -}}

{{/*
Set pgbouncer URL
*/}}
{{- define "posthog.pgbouncer.url" -}}
    postgres://{{- .Values.postgresql.postgresqlUsername -}}:{{- template "posthog.postgresql.password" . -}}@{{- template "posthog.pgbouncer.host" .  -}}:{{- template "posthog.pgbouncer.port" . -}}/{{- .Values.postgresql.postgresqlDatabase }}
{{- end -}}

{*
   ------ REDIS ------
*}

{{/*
Return the Redis fullname
*/}}
{{- define "posthog.redis.fullname" -}}
{{- if .Values.redis.fullnameOverride -}}
{{- .Values.redis.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else if .Values.redis.nameOverride -}}
{{- printf "%s-%s" .Release.Name .Values.redis.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" (include "posthog.fullname" .) "redis" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Return the Redis host
*/}}
{{- define "posthog.redis.host" -}}
{{- if .Values.redis.enabled }}
    {{- printf "%s-master" (include "posthog.redis.fullname" .) -}}
{{- else -}}
    {{- printf "%s" .Values.externalRedis.host -}}
{{- end -}}
{{- end -}}

{{/*
Return the Redis port
*/}}
{{- define "posthog.redis.port" -}}
{{- if .Values.redis.enabled }}
    {{- printf "6379" | quote -}}
{{- else -}}
    {{- .Values.externalRedis.port | quote -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a secret object for Redis should be created
*/}}
{{- define "posthog.redis.createSecret" -}}
{{- if and (not .Values.redis.enabled) (not .Values.externalRedis.existingSecret) .Values.externalRedis.password }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return the Redis secret name
*/}}
{{- define "posthog.redis.secretName" -}}
{{- if .Values.redis.enabled }}
    {{- if .Values.redis.auth.existingSecret }}
        {{- printf "%s" .Values.redis.auth.existingSecret -}}
    {{- else -}}
        {{- printf "%s" (include "posthog.redis.fullname" .) -}}
    {{- end -}}
{{- else if .Values.externalRedis.existingSecret }}
    {{- printf "%s" .Values.externalRedis.existingSecret -}}
{{- else -}}
    {{- printf "%s-external" (include "posthog.redis.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the Redis secret key
*/}}
{{- define "posthog.redis.secretPasswordKey" -}}
{{- if and .Values.redis.enabled .Values.redis.auth.existingSecret }}
    {{- required "You need to provide existingSecretPasswordKey when an existingSecret is specified in redis" .Values.redis.auth.existingSecretPasswordKey | printf "%s" }}
{{- else if and (not .Values.redis.enabled) .Values.externalRedis.existingSecret }}
    {{- required "You need to provide existingSecretPasswordKey when an existingSecret is specified in redis" .Values.externalRedis.existingSecretPasswordKey | printf "%s" }}
{{- else -}}
    {{- printf "redis-password" -}}
{{- end -}}
{{- end -}}

{{/*
Return whether Redis uses password authentication or not
*/}}
{{- define "posthog.redis.auth.enabled" -}}
{{- if or (and .Values.redis.enabled .Values.redis.auth.enabled) (and (not .Values.redis.enabled) (or .Values.externalRedis.password .Values.externalRedis.existingSecret)) }}
    {{- true -}}
{{- end -}}
{{- end -}}

{*
   ------ CLICKHOUSE ------
*}

{{/*
Set clickhouse fullname
*/}}
{{- define "posthog.clickhouse.fullname" -}}
{{- if .Values.clickhouse.fullnameOverride -}}
{{- .Values.clickhouse.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" "clickhouse" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Set statsd host
*/}}
{{- define "posthog.statsd.host" -}}
{{- template "posthog.fullname" . -}}-statsd
{{- end -}}


{{/*
Set kafka fullname
*/}}
{{- define "posthog.kafka.fullname" -}}
{{- if .Values.kafka.fullnameOverride -}}
{{- .Values.kafka.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else if .Values.kafka.nameOverride -}}
{{- printf "%s-%s" .Release.Name .Values.kafka.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" (include "posthog.fullname" .) "kafka" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Set kafka host
*/}}
{{- define "posthog.kafka.host" -}}
{{- if .Values.kafka.host -}}
    {{- .Values.kafka.host | quote -}}
{{- else -}}
{{- template "posthog.kafka.fullname" . -}}
{{- end -}}
{{- end -}}

{{/*
Set kafka port
*/}}
{{- define "posthog.kafka.port" -}}
{{- if .Values.kafka.port -}}
    {{- .Values.kafka.port -}}
{{- else -}}
{{- default 9092 .Values.kafka.port -}}
{{- end -}}
{{- end -}}

{{/*
Set kafka url
*/}}
{{- define "posthog.kafka.url" -}}
{{- if .Values.kafka.url -}}
    {{- .Values.kafka.url | quote -}}
{{- else -}}
    "kafka://{{- template "posthog.kafka.host" . -}}:{{-  template "posthog.kafka.port" . -}}"
{{- end -}}
{{- end -}}

{{/*
Set kafka url
*/}}
{{- define "posthog.kafka.url_no_protocol" -}}
{{- if .Values.kafka.url -}}
    {{- .Values.kafka.url | quote -}}
{{- else -}}
    "{{- template "posthog.kafka.host" . -}}:{{-  template "posthog.kafka.port" . -}}"
{{- end -}}
{{- end -}}

{{/*
Set site url
*/}}
{{- define "posthog.site.url" -}}
{{- if .Values.ingress.hostname -}}
    "https://{{ .Values.ingress.hostname }}"
{{- else -}}
    "http://127.0.0.1:8000"
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "posthog.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "posthog.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{- define "posthog.helmOperation" -}}
{{- if .Release.IsUpgrade -}}
    upgrade
{{- else -}}
    install
{{- end -}}
{{- end -}}

{{- define "ingress.type" -}}
{{- if ne (.Values.ingress.type | toString) "<nil>" -}}
  {{ .Values.ingress.type }}
{{- else if .Values.ingress.nginx.enabled -}}
  nginx
{{- else if (eq (.Values.cloud | toString) "gcp") -}}
  clb
{{- end -}}
{{- end -}}


{{- define "posthog.helmInstallInfo" -}}
{{- $info := dict }}
{{- $info := set $info "cloud" (required "'cloud' value is required, e.g. 'gcp', 'aws', 'do', 'private', ..." .Values.cloud) -}}
{{- $info := set $info "chart_version" .Chart.Version -}}
{{- $info := set $info "release_name" .Release.Name -}}
{{- $info := set $info "release_revision" .Release.Revision -}}
{{- $info := set $info "hostname" .Values.ingress.hostname -}}
{{- $info := set $info "operation" (include "posthog.helmOperation" .) -}}
{{- $info := set $info "ingress_type" (include "ingress.type" .) -}}
{{- $info := set $info "deployment_type" (.Values.deploymentType | default "helm") -}}
{{- $info := set $info "kube_version" .Capabilities.KubeVersion.Version -}}
{{ toJson $info | quote }}
{{- end -}}

{{- define "posthog.deploymentEnv" -}}
    helm_{{ .Values.cloud }}_ha
{{- end -}}

{{- define "ingress.letsencrypt" -}}
{{- if ne (.Values.ingress.letsencrypt | toString) "<nil>" -}}
  {{ .Values.ingress.letsencrypt }}
{{- else if and (and (.Values.ingress.nginx.enabled) ( index .Values "cert-manager" "enabled" )) (ne (.Values.ingress.hostname | toString) "<nil>")  -}}
  true
{{- else -}}
  false
{{- end -}}
{{- end -}}
