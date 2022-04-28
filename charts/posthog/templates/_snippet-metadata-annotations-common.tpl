{{/*
    Common metadata.annotations definition.
*/}}
{{- define "_snippet-metadata-annotations-common" }}
"meta.helm.sh/release-name": {{ .Release.Name | quote }}
"meta.helm.sh/release-namespace": {{ .Release.Namespace | quote }}
{{- end }}
