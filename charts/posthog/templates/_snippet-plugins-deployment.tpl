# An abstract deployment / hpa pair for defining the plugin-server deployments.
# This may be an abstraction too far so if you end up putting loads of if
# statements in here then it's worth considering restructuring.

{{ define "plugins-deployment" }}
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ template "posthog.fullname" .root }}-{{ .name }}
  labels: {{- include "_snippet-metadata-labels-common" .root | nindent 4 }}
  annotations: {{- include "_snippet-metadata-annotations-common" .root | nindent 4 }}
spec:
  selector:
    matchLabels:
        app: {{ template "posthog.fullname" .root }}
        release: "{{ .root.Release.Name }}"
        role: {{ .name }}
  {{- if not .params.hpa.enabled }}
  replicas: {{ .params.replicacount }}
  {{- end }}

  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: {{ .params.rollout.maxSurge }}
      maxUnavailable: {{ .params.rollout.maxUnavailable }}

  template:
    metadata:
      annotations:
        checksum/secrets.yaml: {{ include (print $.root.Template.BasePath "/secrets.yaml") .root | sha256sum }}
        {{- if .params.podAnnotations }}
        {{- toYaml .params.podAnnotations | nindent 8 }}
        {{- end }}
      labels:
        app: {{ template "posthog.fullname" .root }}
        release: "{{ .root.Release.Name }}"
        role: {{ .name }}
        {{- if (eq (default .root.Values.image.tag "none") "latest") }}
        date: "{{ now | unixEpoch }}"
        {{- end }}
        {{- if .params.podLabels }}
        {{- toYaml .params.podLabels | nindent 8 }}
        {{- end }}
    spec:
      serviceAccountName: {{ template "posthog.serviceAccountName" .root }}

      {{- if .params.affinity }}
      affinity:
        {{- toYaml .params.affinity | nindent 8 }}
      {{- end }}

      {{- if .params.nodeSelector }}
      nodeSelector:
        {{- toYaml .params.nodeSelector | nindent 8 }}
      {{- end }}

      {{- if .params.tolerations }}
      tolerations:
        {{- toYaml .params.tolerations | nindent 8 }}
      {{- end }}

      {{- if .params.topologySpreadConstraints }}
      topologySpreadConstraints:
        {{- toYaml .params.topologySpreadConstraints | nindent 8 }}
      {{- end }}

      {{- if .params.schedulerName }}
      schedulerName: "{{ .params.schedulerName }}"
      {{- end }}

      {{- if .params.priorityClassName }}
      priorityClassName: "{{ .params.priorityClassName }}"
      {{- end }}

      {{- if .root.Values.image.imagePullSecrets }}
      imagePullSecrets:
        {{- toYaml .root.Values.image.imagePullSecrets | nindent 8 }}
      {{- end }}

      # I do not know for sure if the old one has been used anywhere, so do both :(
      {{- if .root.Values.image.pullSecrets }}
      imagePullSecrets:
        {{- range .root.Values.image.pullSecrets }}
        - name: {{ . }}
        {{- end }}
      {{- end }}

      {{- if .params.podSecurityContext.enabled }}
      securityContext: {{- omit .params.podSecurityContext "enabled" | toYaml | nindent 8 }}
      {{- end }}

      containers:
      - name: {{ .root.Chart.Name }}-{{ .name }}
        image: {{ template "posthog.image.fullPath" .root }}
        imagePullPolicy: {{ .root.Values.image.pullPolicy }}
        command:
          - ./bin/plugin-server
          - --no-restart-loop
        ports:
        # Expose the port on which the healtchheck endpoint listens
        - containerPort: 6738
        env:
        {{ if .mode }}
        - name: PLUGIN_SERVER_MODE
          value: {{ .mode }}
        {{ end }}

        - name: SENTRY_DSN
          value: {{ .params.sentryDSN | default .root.Values.sentryDSN }}

        # Kafka env variables
        {{- include "snippet.kafka-env" .root | nindent 8 }}

        # Object Storage env variables
        {{- include "snippet.objectstorage-env" .root | nindent 8 }}

        # Redis env variables
        {{- include "snippet.redis-env" .root | nindent 8 }}

        # statsd env variables
        {{- include "snippet.statsd-env" .root | nindent 8 }}

        {{- include "snippet.posthog-env" .root | indent 8 }}
        {{- include "snippet.postgresql-env" .root | nindent 8 }}
        {{- include "snippet.clickhouse-env" .root | nindent 8 }}
        {{- if .root.Values.env }}
        {{- toYaml .root.Values.env | nindent 8 }}
        {{- end }}
        {{- if .params.env }}
        {{- toYaml .params.env | nindent 8 }}
        {{- end }}
        livenessProbe:
          exec:
            command:
              # Just check that we can at least exec to the container
              - "true"
          failureThreshold: {{ .params.livenessProbe.failureThreshold }}
          initialDelaySeconds: {{ .params.livenessProbe.initialDelaySeconds }}
          periodSeconds: {{ .params.livenessProbe.periodSeconds }}
          successThreshold: {{ .params.livenessProbe.successThreshold }}
          timeoutSeconds: {{ .params.livenessProbe.timeoutSeconds }}
        readinessProbe:
          failureThreshold: {{ .params.readinessProbe.failureThreshold }}
          httpGet:
            path: /_health
            port: 6738
            scheme: HTTP
          initialDelaySeconds: {{ .params.readinessProbe.initialDelaySeconds }}
          periodSeconds: {{ .params.readinessProbe.periodSeconds }}
          successThreshold: {{ .params.readinessProbe.successThreshold }}
          timeoutSeconds: {{ .params.readinessProbe.timeoutSeconds }}
        resources:
          {{- toYaml .params.resources | nindent 12 }}
        {{- if .params.securityContext.enabled }}
        securityContext:
          {{- omit .params.securityContext "enabled" | toYaml | nindent 12 }}
        {{- end }}
      initContainers:
      {{- include "_snippet-initContainers-wait-for-service-dependencies" .root | indent 8 }}
      {{- include "_snippet-initContainers-wait-for-migrations" .root | indent 8 }}

---

{{ if .params.hpa.enabled }}
apiVersion: autoscaling/v2beta2
kind: HorizontalPodAutoscaler
metadata:
  name: {{ template "posthog.fullname" .root }}-{{ .name }}
  labels: {{- include "_snippet-metadata-labels-common" .root | nindent 4 }}
spec:
  scaleTargetRef:
    kind: Deployment
    apiVersion: apps/v1
    name: {{ template "posthog.fullname" .root }}-{{ .name }}
  minReplicas: {{ .params.hpa.minpods }}
  maxReplicas: {{ .params.hpa.maxpods }}
  metrics:
  {{- with .params.hpa.cputhreshold }}
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: {{ . }}
  {{- end }}
  behavior: 
    {{ toYaml .params.hpa.behavior | nindent 4 }}
{{- end }}

{{ end }}
