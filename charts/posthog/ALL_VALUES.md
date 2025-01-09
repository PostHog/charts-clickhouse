# PostHog Helm chart configuration

![Version: 30.46.0](https://img.shields.io/badge/Version-30.46.0-informational?style=flat-square) ![AppVersion: 1.43.0](https://img.shields.io/badge/AppVersion-1.43.0-informational?style=flat-square)

## Configuration

The following table lists the configurable parameters of the PostHog chart and their default values.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| cloud | string | `nil` | Cloud service being deployed on (example: `aws`, `azure`, `do`, `gcp`, `other`). |
| notificationEmail | string | `nil` | Notification email for notifications to be sent to from the PostHog stack |
| siteUrl | string | `nil` |  |
| image.repository | string | `"posthog/posthog"` | PostHog image repository to use. |
| image.sha | string | `nil` | PostHog image SHA to use (example: `sha256:20af35fca6756d689d6705911a49dd6f2f6631e001ad43377b605cfc7c133eb4`). |
| image.tag | string | `nil` | PostHog image tag to use (example: `release-1.43.0`). |
| image.default | string | `":latest"` | PostHog default image. Do not overwrite, use `image.sha` or `image.tag` instead. |
| image.pullPolicy | string | `"Always"` | PostHog image pull policy. |
| image.pullSecrets | list | `[]` |  |
| sentryDSN | string | `nil` | Sentry endpoint to send errors to. |
| posthogSecretKey.existingSecret | string | `nil` | Specify that the key should be pulled from an existing secret key. By default the chart will generate a secret and create a Kubernetes Secret containing it. |
| posthogSecretKey.existingSecretKey | string | `"posthog-secret"` | Specify the key within the secret from which SECRET_KEY should be taken. |
| env | list | `[]` | Environment variables to inject into every PostHog deployment. |
| migrate.enabled | bool | `true` | Whether to install the PostHog migrate job or not. |
| events.enabled | bool | `true` | Whether to install the PostHog events stack or not. |
| events.replicacount | int | `1` | Count of events pods to run. This setting is ignored if `events.hpa.enabled` is set to `true`. |
| events.hpa.enabled | bool | `false` | Whether to create a HorizontalPodAutoscaler for the events stack. |
| events.hpa.cputhreshold | int | `60` | CPU threshold percent for the events stack HorizontalPodAutoscaler. |
| events.hpa.minpods | int | `1` | Min pods for the events stack HorizontalPodAutoscaler. |
| events.hpa.maxpods | int | `10` | Max pods for the events stack HorizontalPodAutoscaler. |
| events.hpa.behavior | string | `nil` | Set the HPA behavior. See https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/ for configuration options |
| events.pdb.enabled | bool | `false` |  |
| events.rollout.maxSurge | string | `"25%"` |  |
| events.rollout.maxUnavailable | string | `"25%"` |  |
| events.env | list | `[]` | Additional env variables to inject into the events stack, uses `web.env` if empty. |
| events.securityContext | object | `{"enabled":false}` | Container security context for the events stack HorizontalPodAutoscaler. |
| events.podSecurityContext | object | `{"enabled":false}` | Pod security context for the events stack HorizontalPodAutoscaler. |
| recordings.enabled | bool | `false` | Whether to install the PostHog recordings stack or not. |
| recordings.ingressEnabled | bool | `false` | Whether to route /s traffic to the recordings stack instead of the events stack |
| recordings.replicacount | int | `1` | Count of recordings pods to run. This setting is ignored if `recordings.hpa.enabled` is set to `true`. |
| recordings.hpa.enabled | bool | `false` | Whether to create a HorizontalPodAutoscaler for the recordings stack. |
| recordings.hpa.cputhreshold | int | `60` | CPU threshold percent for the recordings stack HorizontalPodAutoscaler. |
| recordings.hpa.minpods | int | `1` | Min pods for the recordings stack HorizontalPodAutoscaler. |
| recordings.hpa.maxpods | int | `10` | Max pods for the recordings stack HorizontalPodAutoscaler. |
| recordings.hpa.behavior | string | `nil` | Set the HPA behavior. See https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/ for configuration options |
| recordings.pdb.enabled | bool | `false` |  |
| recordings.rollout.maxSurge | string | `"25%"` |  |
| recordings.rollout.maxUnavailable | string | `"25%"` |  |
| recordings.env | list | `[]` | Additional env variables to inject into the recordings stack, uses `web.env` if empty. |
| recordings.securityContext | object | `{"enabled":false}` | Container security context for the recordings stack HorizontalPodAutoscaler. |
| recordings.podSecurityContext | object | `{"enabled":false}` | Pod security context for the recordings stack HorizontalPodAutoscaler. |
| capture.ingress.enabled | bool | `false` |  |
| capture.ingress.service.name | string | `"capture"` |  |
| capture.ingress.service.port | int | `3000` |  |
| decide.enabled | bool | `false` | Whether to install the PostHog decide stack or not. |
| decide.ingressEnabled | bool | `false` |  |
| decide.replicacount | int | `1` | Count of decide pods to run. This setting is ignored if `decide.hpa.enabled` is set to `true`. |
| decide.hpa.enabled | bool | `false` | Whether to create a HorizontalPodAutoscaler for the decide stack. |
| decide.hpa.cputhreshold | int | `60` | CPU threshold percent for the decide stack HorizontalPodAutoscaler. |
| decide.hpa.minpods | int | `1` | Min pods for the decide stack HorizontalPodAutoscaler. |
| decide.hpa.maxpods | int | `10` | Max pods for the decide stack HorizontalPodAutoscaler. |
| decide.hpa.behavior | string | `nil` | Set the HPA behavior. See https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/ for configuration options |
| decide.pdb.enabled | bool | `true` | Whether to create a PodDisruptionBudget for the decide stack. |
| decide.pdb.maxUnavailable | int | `1` | Maximum number of decide pods that can be unavailable at any time |
| decide.rollout.maxSurge | string | `"25%"` |  |
| decide.rollout.maxUnavailable | string | `"25%"` |  |
| decide.env | list | `[]` | Additional env variables to inject into the decide stack, uses `web.env` if empty. |
| decide.securityContext | object | `{"enabled":false}` | Container security context for the decide stack HorizontalPodAutoscaler. |
| decide.podSecurityContext | object | `{"enabled":false}` | Pod security context for the decide stack HorizontalPodAutoscaler. |
| web.enabled | bool | `true` | Whether to install the PostHog web stack or not. |
| web.image | object | `{}` |  |
| web.deployment.apiVersion | string | `"apps/v1"` |  |
| web.deployment.kind | string | `"Deployment"` |  |
| web.deployment.strategy | string | `"rollingUpdate"` |  |
| web.podAnnotations | string | `nil` |  |
| web.replicacount | int | `1` | Count of web pods to run. This setting is ignored if `web.hpa.enabled` is set to `true`. |
| web.hpa.enabled | bool | `false` | Whether to create a HorizontalPodAutoscaler for the web stack. |
| web.hpa.cputhreshold | int | `60` | CPU threshold percent for the web stack HorizontalPodAutoscaler. |
| web.hpa.minpods | int | `1` | Min pods for the web stack HorizontalPodAutoscaler. |
| web.hpa.maxpods | int | `10` | Max pods for the web stack HorizontalPodAutoscaler. |
| web.hpa.behavior | string | `nil` | Set the HPA behavior. See https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/ for configuration options |
| web.pdb.enabled | bool | `false` |  |
| web.rollout.maxSurge | string | `"25%"` |  |
| web.rollout.maxUnavailable | string | `"25%"` |  |
| web.resources | object | `{}` | Resource limits for web service. |
| web.env | list | `[{"name":"SOCIAL_AUTH_GOOGLE_OAUTH2_KEY","value":null},{"name":"SOCIAL_AUTH_GOOGLE_OAUTH2_SECRET","value":null},{"name":"SOCIAL_AUTH_GOOGLE_OAUTH2_WHITELISTED_DOMAINS","value":"posthog.com"}]` | Additional env variables to inject into the web stack deployment. |
| web.env[0] | object | `{"name":"SOCIAL_AUTH_GOOGLE_OAUTH2_KEY","value":null}` | Set google oauth 2 key. Requires posthog ee license. |
| web.env[1] | object | `{"name":"SOCIAL_AUTH_GOOGLE_OAUTH2_SECRET","value":null}` | Set google oauth 2 secret. Requires posthog ee license. |
| web.env[2] | object | `{"name":"SOCIAL_AUTH_GOOGLE_OAUTH2_WHITELISTED_DOMAINS","value":"posthog.com"}` | Set google oauth 2 whitelisted domains users can log in from. |
| web.internalMetrics.capture | bool | `false` | Deprecated: Whether to capture information on operation of posthog into posthog, exposed in /instance/status page |
| web.nodeSelector | object | `{}` | Node labels for web stack deployment. |
| web.tolerations | list | `[]` | Toleration labels for web stack deployment. |
| web.affinity | object | `{}` | Affinity settings for web stack deployment. |
| web.secureCookies | bool | `true` |  |
| web.livenessProbe.failureThreshold | int | `3` | The liveness probe failure threshold |
| web.livenessProbe.initialDelaySeconds | int | `0` | The liveness probe initial delay seconds |
| web.livenessProbe.periodSeconds | int | `5` | The liveness probe period seconds |
| web.livenessProbe.successThreshold | int | `1` | The liveness probe success threshold |
| web.livenessProbe.timeoutSeconds | int | `2` | The liveness probe timeout seconds |
| web.readinessProbe.failureThreshold | int | `3` | The readiness probe failure threshold |
| web.readinessProbe.initialDelaySeconds | int | `0` | The readiness probe initial delay seconds |
| web.readinessProbe.periodSeconds | int | `30` | The readiness probe period seconds |
| web.readinessProbe.successThreshold | int | `1` | The readiness probe success threshold |
| web.readinessProbe.timeoutSeconds | int | `5` | The readiness probe timeout seconds |
| web.startupProbe.failureThreshold | int | `6` | The startup probe failure threshold |
| web.startupProbe.initialDelaySeconds | int | `0` | The startup probe initial delay seconds |
| web.startupProbe.periodSeconds | int | `10` | The startup probe period seconds |
| web.startupProbe.successThreshold | int | `1` | The startup probe success threshold |
| web.startupProbe.timeoutSeconds | int | `5` | The startup probe timeout seconds |
| web.securityContext | object | `{"enabled":false}` | Container security context for web stack deployment. |
| web.podSecurityContext | object | `{"enabled":false}` | Pod security context for web stack deployment. |
| worker.enabled | bool | `true` | Whether to install the PostHog worker stack or not. |
| worker.replicacount | int | `1` | Count of worker pods to run. This setting is ignored if `worker.hpa.enabled` is set to `true`. |
| worker.consumers[0].name | string | `"default"` |  |
| worker.hpa.enabled | bool | `false` | Whether to create a HorizontalPodAutoscaler for the worker stack. |
| worker.hpa.cputhreshold | int | `60` | CPU threshold percent for the worker stack HorizontalPodAutoscaler. |
| worker.hpa.minpods | int | `1` | Min pods for the worker stack HorizontalPodAutoscaler. |
| worker.hpa.maxpods | int | `10` | Max pods for the worker stack HorizontalPodAutoscaler. |
| worker.hpa.behavior | string | `nil` | Set the HPA behavior. See https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/ for configuration options |
| worker.rollout.maxSurge | string | `"25%"` |  |
| worker.rollout.maxUnavailable | string | `"25%"` |  |
| worker.env | list | `[]` | Additional env variables to inject into the worker stack deployment. |
| worker.resources | object | `{}` | Resource limits for the worker stack deployment. |
| worker.nodeSelector | object | `{}` | Node labels for the worker stack deployment. |
| worker.tolerations | list | `[]` | Toleration labels for the worker stack deployment. |
| worker.affinity | object | `{}` | Affinity settings for the worker stack deployment. |
| worker.securityContext | object | `{"enabled":false}` | Container security context for the worker stack deployment. |
| worker.podSecurityContext | object | `{"enabled":false}` | Pod security context for the worker stack deployment. |
| plugins.enabled | bool | `true` | Whether to install the PostHog plugin-server stack or not. This service handles data ingestion into ClickHouse, running apps and async jobs. To scale these components separately, instead use the individual component deployments, pluginsIngestion, pluginsAsync, pluginsJobs, and pluginsScheduler. |
| plugins.replicacount | int | `1` | Count of plugin-server pods to run. This setting is ignored if `plugins.hpa.enabled` is set to `true`. |
| plugins.hpa.enabled | bool | `false` | Whether to create a HorizontalPodAutoscaler for the plugin stack. |
| plugins.hpa.cputhreshold | int | `60` | CPU threshold percent for the plugin-server stack HorizontalPodAutoscaler. |
| plugins.hpa.minpods | int | `1` | Min pods for the plugin-server stack HorizontalPodAutoscaler. |
| plugins.hpa.maxpods | int | `10` | Max pods for the plugin-server stack HorizontalPodAutoscaler. |
| plugins.hpa.behavior | string | `nil` | Set the HPA behavior. See https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/ for configuration options |
| plugins.rollout.maxSurge | string | `"25%"` |  |
| plugins.rollout.maxUnavailable | string | `"25%"` |  |
| plugins.env | list | `[]` | Additional env variables to inject into the plugin-server stack deployment. |
| plugins.resources | object | `{}` | Resource limits for the plugin-server stack deployment. |
| plugins.nodeSelector | object | `{}` | Node labels for the plugin-server stack deployment. |
| plugins.tolerations | list | `[]` | Toleration labels for the plugin-server stack deployment. |
| plugins.affinity | object | `{}` | Affinity settings for the plugin-server stack deployment. |
| plugins.securityContext | object | `{"enabled":false}` | Container security context for the plugin-server stack deployment. |
| plugins.podSecurityContext | object | `{"enabled":false}` | Pod security context for the plugin-server stack deployment. |
| plugins.livenessProbe.failureThreshold | int | `3` | The liveness probe failure threshold |
| plugins.livenessProbe.initialDelaySeconds | int | `10` | The liveness probe initial delay seconds |
| plugins.livenessProbe.periodSeconds | int | `10` | The liveness probe period seconds |
| plugins.livenessProbe.successThreshold | int | `1` | The liveness probe success threshold |
| plugins.livenessProbe.timeoutSeconds | int | `2` | The liveness probe timeout seconds |
| plugins.readinessProbe.failureThreshold | int | `3` | The readiness probe failure threshold |
| plugins.readinessProbe.initialDelaySeconds | int | `50` | The readiness probe initial delay seconds |
| plugins.readinessProbe.periodSeconds | int | `30` | The readiness probe period seconds |
| plugins.readinessProbe.successThreshold | int | `1` | The readiness probe success threshold |
| plugins.readinessProbe.timeoutSeconds | int | `5` | The readiness probe timeout seconds |
| plugins.sentryDSN | string | `nil` | Sentry endpoint to send errors to. Falls back to global sentryDSN |
| pluginsAsync.enabled | bool | `false` | Whether to install the PostHog plugin-server async stack or not. If disabled (default), plugins service handles both ingestion and running of async tasks. Allows for separate scaling of this service. |
| pluginsAsync.replicacount | int | `1` | Count of plugin-server-async pods to run. This setting is ignored if `pluginsAsync.hpa.enabled` is set to `true`. |
| pluginsAsync.hpa.enabled | bool | `false` | Whether to create a HorizontalPodAutoscaler for the plugin stack. |
| pluginsAsync.hpa.cputhreshold | int | `60` | CPU threshold percent for the plugin-server stack HorizontalPodAutoscaler. |
| pluginsAsync.hpa.minpods | int | `1` | Min pods for the plugin-server stack HorizontalPodAutoscaler. |
| pluginsAsync.hpa.maxpods | int | `10` | Max pods for the plugin-server stack HorizontalPodAutoscaler. |
| pluginsAsync.hpa.behavior | string | `nil` | Set the HPA behavior. See https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/ for configuration options |
| pluginsAsync.rollout.maxSurge | string | `"25%"` |  |
| pluginsAsync.rollout.maxUnavailable | string | `"25%"` |  |
| pluginsAsync.env | list | `[]` | Additional env variables to inject into the plugin-server stack deployment. |
| pluginsAsync.resources | object | `{}` | Resource limits for the plugin-server stack deployment. |
| pluginsAsync.nodeSelector | object | `{}` | Node labels for the plugin-server stack deployment. |
| pluginsAsync.tolerations | list | `[]` | Toleration labels for the plugin-server stack deployment. |
| pluginsAsync.affinity | object | `{}` | Affinity settings for the plugin-server stack deployment. |
| pluginsAsync.securityContext | object | `{"enabled":false}` | Container security context for the plugin-server stack deployment. |
| pluginsAsync.podSecurityContext | object | `{"enabled":false}` | Pod security context for the plugin-server stack deployment. |
| pluginsAsync.livenessProbe.failureThreshold | int | `3` | The liveness probe failure threshold |
| pluginsAsync.livenessProbe.initialDelaySeconds | int | `10` | The liveness probe initial delay seconds |
| pluginsAsync.livenessProbe.periodSeconds | int | `10` | The liveness probe period seconds |
| pluginsAsync.livenessProbe.successThreshold | int | `1` | The liveness probe success threshold |
| pluginsAsync.livenessProbe.timeoutSeconds | int | `2` | The liveness probe timeout seconds |
| pluginsAsync.readinessProbe.failureThreshold | int | `3` | The readiness probe failure threshold |
| pluginsAsync.readinessProbe.initialDelaySeconds | int | `50` | The readiness probe initial delay seconds |
| pluginsAsync.readinessProbe.periodSeconds | int | `30` | The readiness probe period seconds |
| pluginsAsync.readinessProbe.successThreshold | int | `1` | The readiness probe success threshold |
| pluginsAsync.readinessProbe.timeoutSeconds | int | `5` | The readiness probe timeout seconds |
| pluginsAsync.sentryDSN | string | `nil` | Sentry endpoint to send errors to. Falls back to global sentryDSN |
| pluginsIngestion | object | `{"affinity":{},"enabled":false,"env":[{"name":"INGESTION_OVERFLOW_ENABLED","value":"false"}],"hpa":{"behavior":null,"cputhreshold":60,"enabled":false,"maxpods":10,"minpods":1},"livenessProbe":{"failureThreshold":3,"initialDelaySeconds":10,"periodSeconds":10,"successThreshold":1,"timeoutSeconds":2},"nodeSelector":{},"podSecurityContext":{"enabled":false},"readinessProbe":{"failureThreshold":3,"initialDelaySeconds":50,"periodSeconds":30,"successThreshold":1,"timeoutSeconds":5},"replicacount":1,"resources":{},"rollout":{"maxSurge":"25%","maxUnavailable":"25%"},"securityContext":{"enabled":false},"sentryDSN":null,"tolerations":[]}` | A deconstructed plugin-server that handles the various workloads of the pipeline separately. For most workloads this will not be needed, rather you can disable the below plugins* and instead just use `plugins.enabled=true`. Note that the behaviour of pluginsAsync is unchanged to maintain backwards compatibility. |
| pluginsIngestion.enabled | bool | `false` | Whether to install the PostHog plugin-server ingestion capability as an individual workload. |
| pluginsIngestion.replicacount | int | `1` | Count of plugin-server pods to run. This setting is ignored if `pluginsIngestion.hpa.enabled` is set to `true`. |
| pluginsIngestion.hpa.enabled | bool | `false` | Whether to create a HorizontalPodAutoscaler for the plugin stack. |
| pluginsIngestion.hpa.cputhreshold | int | `60` | CPU threshold percent for the plugin-server stack HorizontalPodAutoscaler. |
| pluginsIngestion.hpa.minpods | int | `1` | Min pods for the plugin-server stack HorizontalPodAutoscaler. |
| pluginsIngestion.hpa.maxpods | int | `10` | Max pods for the plugin-server stack HorizontalPodAutoscaler. |
| pluginsIngestion.hpa.behavior | string | `nil` | Set the HPA behavior. See https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/ for configuration options |
| pluginsIngestion.env | list | `[{"name":"INGESTION_OVERFLOW_ENABLED","value":"false"}]` | Additional env variables to inject into the plugin-server stack deployment. |
| pluginsIngestion.resources | object | `{}` | Resource limits for the plugin-server stack deployment. |
| pluginsIngestion.nodeSelector | object | `{}` | Node labels for the plugin-server stack deployment. |
| pluginsIngestion.tolerations | list | `[]` | Toleration labels for the plugin-server stack deployment. |
| pluginsIngestion.affinity | object | `{}` | Affinity settings for the plugin-server stack deployment. |
| pluginsIngestion.securityContext | object | `{"enabled":false}` | Container security context for the plugin-server stack deployment. |
| pluginsIngestion.podSecurityContext | object | `{"enabled":false}` | Pod security context for the plugin-server stack deployment. |
| pluginsIngestion.livenessProbe.failureThreshold | int | `3` | The liveness probe failure threshold |
| pluginsIngestion.livenessProbe.initialDelaySeconds | int | `10` | The liveness probe initial delay seconds |
| pluginsIngestion.livenessProbe.periodSeconds | int | `10` | The liveness probe period seconds |
| pluginsIngestion.livenessProbe.successThreshold | int | `1` | The liveness probe success threshold |
| pluginsIngestion.livenessProbe.timeoutSeconds | int | `2` | The liveness probe timeout seconds |
| pluginsIngestion.readinessProbe.failureThreshold | int | `3` | The readiness probe failure threshold |
| pluginsIngestion.readinessProbe.initialDelaySeconds | int | `50` | The readiness probe initial delay seconds |
| pluginsIngestion.readinessProbe.periodSeconds | int | `30` | The readiness probe period seconds |
| pluginsIngestion.readinessProbe.successThreshold | int | `1` | The readiness probe success threshold |
| pluginsIngestion.readinessProbe.timeoutSeconds | int | `5` | The readiness probe timeout seconds |
| pluginsIngestion.sentryDSN | string | `nil` | Sentry endpoint to send errors to. Falls back to global sentryDSN |
| pluginsAnalyticsIngestion.enabled | bool | `false` | Whether to install the PostHog plugin-server analytics ingestion capability as an individual workload. Note that this is different from the `pluginsIngestion` setting above specifically in that the deployment controlled by these settings does not handle session recordings. This deployment is intended to be a replacement for `pluginsIngestion` and is intended to be used along side the `recordingsIngestion` deployment. The reason these values were added is to be able to scale analytics and session recordings events independently, and to be able to roll this out in a backwards compatible way. |
| pluginsAnalyticsIngestion.replicacount | int | `1` | Count of plugin-server pods to run. This setting is ignored if `pluginsAnalyticsIngestion.hpa.enabled` is set to `true`. |
| pluginsAnalyticsIngestion.hpa.enabled | bool | `false` | Whether to create a HorizontalPodAutoscaler for the plugin stack. |
| pluginsAnalyticsIngestion.hpa.cputhreshold | int | `60` | CPU threshold percent for the plugin-server stack HorizontalPodAutoscaler. |
| pluginsAnalyticsIngestion.hpa.minpods | int | `1` | Min pods for the plugin-server stack HorizontalPodAutoscaler. |
| pluginsAnalyticsIngestion.hpa.maxpods | int | `10` | Max pods for the plugin-server stack HorizontalPodAutoscaler. |
| pluginsAnalyticsIngestion.hpa.behavior | string | `nil` | Set the HPA behavior. See https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/ for configuration options |
| pluginsAnalyticsIngestion.rollout.maxSurge | string | `"25%"` |  |
| pluginsAnalyticsIngestion.rollout.maxUnavailable | string | `"25%"` |  |
| pluginsAnalyticsIngestion.env | list | `[{"name":"INGESTION_OVERFLOW_ENABLED","value":"false"}]` | Additional env variables to inject into the plugin-server stack deployment. |
| pluginsAnalyticsIngestion.resources | object | `{}` | Resource limits for the plugin-server stack deployment. |
| pluginsAnalyticsIngestion.nodeSelector | object | `{}` | Node labels for the plugin-server stack deployment. |
| pluginsAnalyticsIngestion.tolerations | list | `[]` | Toleration labels for the plugin-server stack deployment. |
| pluginsAnalyticsIngestion.affinity | object | `{}` | Affinity settings for the plugin-server stack deployment. |
| pluginsAnalyticsIngestion.securityContext | object | `{"enabled":false}` | Container security context for the plugin-server stack deployment. |
| pluginsAnalyticsIngestion.podSecurityContext | object | `{"enabled":false}` | Pod security context for the plugin-server stack deployment. |
| pluginsAnalyticsIngestion.livenessProbe.failureThreshold | int | `3` | The liveness probe failure threshold |
| pluginsAnalyticsIngestion.livenessProbe.initialDelaySeconds | int | `10` | The liveness probe initial delay seconds |
| pluginsAnalyticsIngestion.livenessProbe.periodSeconds | int | `10` | The liveness probe period seconds |
| pluginsAnalyticsIngestion.livenessProbe.successThreshold | int | `1` | The liveness probe success threshold |
| pluginsAnalyticsIngestion.livenessProbe.timeoutSeconds | int | `2` | The liveness probe timeout seconds |
| pluginsAnalyticsIngestion.readinessProbe.failureThreshold | int | `3` | The readiness probe failure threshold |
| pluginsAnalyticsIngestion.readinessProbe.initialDelaySeconds | int | `50` | The readiness probe initial delay seconds |
| pluginsAnalyticsIngestion.readinessProbe.periodSeconds | int | `30` | The readiness probe period seconds |
| pluginsAnalyticsIngestion.readinessProbe.successThreshold | int | `1` | The readiness probe success threshold |
| pluginsAnalyticsIngestion.readinessProbe.timeoutSeconds | int | `5` | The readiness probe timeout seconds |
| pluginsAnalyticsIngestion.sentryDSN | string | `nil` | Sentry endpoint to send errors to. Falls back to global sentryDSN |
| pluginsIngestionOverflow.enabled | bool | `false` | Whether to install the PostHog plugin-server ingestion overflow capability as an individual workload. |
| pluginsIngestionOverflow.replicacount | int | `1` | Count of plugin-server overflow pods to run. This setting is ignored if `pluginsIngestionOverflow.hpa.enabled` is set to `true`. |
| pluginsIngestionOverflow.hpa.enabled | bool | `false` | Whether to create a HorizontalPodAutoscaler for the plugin stack. |
| pluginsIngestionOverflow.hpa.cputhreshold | int | `60` | CPU threshold percent for the plugin-server stack HorizontalPodAutoscaler. |
| pluginsIngestionOverflow.hpa.minpods | int | `1` | Min pods for the plugin-server stack HorizontalPodAutoscaler. |
| pluginsIngestionOverflow.hpa.maxpods | int | `10` | Max pods for the plugin-server stack HorizontalPodAutoscaler. |
| pluginsIngestionOverflow.hpa.behavior | string | `nil` | Set the HPA behavior. See https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/ for configuration options |
| pluginsIngestionOverflow.sentryDSN | string | `nil` | Sentry endpoint to send errors to. Falls back to global sentryDSN |
| recordingsIngestion.enabled | bool | `false` | Whether to install the PostHog session recordings ingestion capability as an individual workload. |
| recordingsIngestion.replicacount | int | `1` | Count of plugin-server pods to run. This setting is ignored if `recordingsIngestion.hpa.enabled` is set to `true`. |
| recordingsIngestion.hpa.enabled | bool | `false` | Whether to create a HorizontalPodAutoscaler for the plugin stack. |
| recordingsIngestion.hpa.cputhreshold | int | `60` | CPU threshold percent for the plugin-server stack HorizontalPodAutoscaler. |
| recordingsIngestion.hpa.minpods | int | `1` | Min pods for the plugin-server stack HorizontalPodAutoscaler. |
| recordingsIngestion.hpa.maxpods | int | `10` | Max pods for the plugin-server stack HorizontalPodAutoscaler. |
| recordingsIngestion.hpa.behavior | string | `nil` | Set the HPA behavior. See https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/ for configuration options |
| recordingsIngestion.keda.enabled | bool | `false` |  |
| recordingsIngestion.keda.config | object | `{"pollingInterval":30}` | Config added to spec at the top level of the `ScaledObject`. |
| recordingsIngestion.keda.kafkaTrigger.enabled | bool | `true` |  |
| recordingsIngestion.keda.kafkaTrigger.metadata.lagThreshold | string | `"1000"` | At what lag value should KEDA scaling start. |
| recordingsIngestion.keda.kafkaTrigger.metadata.activationLagThreshold | string | `"0"` | At what lag value should KEDA scale from 0 replicas. |
| recordingsIngestion.keda.kafkaTrigger.metadata.excludePersistentLag | string | `"true"` |  |
| recordingsIngestion.rollout.maxSurge | string | `"25%"` |  |
| recordingsIngestion.rollout.maxUnavailable | string | `"25%"` |  |
| recordingsIngestion.env | list | `[]` | Additional env variables to inject into the plugin-server stack deployment. |
| recordingsIngestion.resources | object | `{}` | Resource limits for the plugin-server stack deployment. |
| recordingsIngestion.nodeSelector | object | `{}` | Node labels for the plugin-server stack deployment. |
| recordingsIngestion.tolerations | list | `[]` | Toleration labels for the plugin-server stack deployment. |
| recordingsIngestion.affinity | object | `{}` | Affinity settings for the plugin-server stack deployment. |
| recordingsIngestion.securityContext | object | `{"enabled":false}` | Container security context for the plugin-server stack deployment. |
| recordingsIngestion.podSecurityContext | object | `{"enabled":false}` | Pod security context for the plugin-server stack deployment. |
| recordingsIngestion.livenessProbe.failureThreshold | int | `3` | The liveness probe failure threshold |
| recordingsIngestion.livenessProbe.initialDelaySeconds | int | `10` | The liveness probe initial delay seconds |
| recordingsIngestion.livenessProbe.periodSeconds | int | `10` | The liveness probe period seconds |
| recordingsIngestion.livenessProbe.successThreshold | int | `1` | The liveness probe success threshold |
| recordingsIngestion.livenessProbe.timeoutSeconds | int | `2` | The liveness probe timeout seconds |
| recordingsIngestion.readinessProbe.failureThreshold | int | `3` | The readiness probe failure threshold |
| recordingsIngestion.readinessProbe.initialDelaySeconds | int | `50` | The readiness probe initial delay seconds |
| recordingsIngestion.readinessProbe.periodSeconds | int | `30` | The readiness probe period seconds |
| recordingsIngestion.readinessProbe.successThreshold | int | `1` | The readiness probe success threshold |
| recordingsIngestion.readinessProbe.timeoutSeconds | int | `5` | The readiness probe timeout seconds |
| recordingsIngestion.sentryDSN | string | `nil` | Sentry endpoint to send errors to. Falls back to global sentryDSN |
| recordingsBlobIngestion.enabled | bool | `false` | Whether to install the PostHog session recordings blob ingestion capability as an individual workload. |
| recordingsBlobIngestion.replicacount | int | `1` | Count of plugin-server pods to run. This setting is ignored if `recordingsBlobIngestion.hpa.enabled` is set to `true`. |
| recordingsBlobIngestion.volumeMounts[0].mountPath | string | `"/session-buffers"` |  |
| recordingsBlobIngestion.volumeMounts[0].name | string | `"session-buffers"` |  |
| recordingsBlobIngestion.volumes[0].name | string | `"session-buffers"` |  |
| recordingsBlobIngestion.volumes[0].ephemeral.volumeClaimTemplate.spec.accessModes[0] | string | `"ReadWriteOnce"` |  |
| recordingsBlobIngestion.volumes[0].ephemeral.volumeClaimTemplate.spec.storageClassName | string | `"gp3"` |  |
| recordingsBlobIngestion.volumes[0].ephemeral.volumeClaimTemplate.spec.resources.requests.storage | string | `"50Gi"` |  |
| recordingsBlobIngestion.hpa.enabled | bool | `false` | Whether to create a HorizontalPodAutoscaler for the plugin stack. |
| recordingsBlobIngestion.hpa.cputhreshold | int | `60` | CPU threshold percent for the plugin-server stack HorizontalPodAutoscaler. |
| recordingsBlobIngestion.hpa.minpods | int | `1` | Min pods for the plugin-server stack HorizontalPodAutoscaler. |
| recordingsBlobIngestion.hpa.maxpods | int | `10` | Max pods for the plugin-server stack HorizontalPodAutoscaler. |
| recordingsBlobIngestion.hpa.behavior | string | `nil` | Set the HPA behavior. See https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/ for configuration options |
| recordingsBlobIngestion.keda.enabled | bool | `false` |  |
| recordingsBlobIngestion.keda.config | object | `{"pollingInterval":30}` | Config added to spec at the top level of the `ScaledObject`. |
| recordingsBlobIngestion.keda.kafkaTrigger.enabled | bool | `true` |  |
| recordingsBlobIngestion.keda.kafkaTrigger.metadata.lagThreshold | string | `"1000"` | At what lag value should KEDA scaling start. |
| recordingsBlobIngestion.keda.kafkaTrigger.metadata.activationLagThreshold | string | `"0"` | At what lag value should KEDA scale from 0 replicas. |
| recordingsBlobIngestion.keda.kafkaTrigger.metadata.excludePersistentLag | string | `"true"` |  |
| recordingsBlobIngestion.rollout.maxSurge | string | `"25%"` |  |
| recordingsBlobIngestion.rollout.maxUnavailable | string | `"25%"` |  |
| recordingsBlobIngestion.env | list | `[]` | Additional env variables to inject into the plugin-server stack deployment. |
| recordingsBlobIngestion.resources | object | `{}` | Resource limits for the plugin-server stack deployment. |
| recordingsBlobIngestion.nodeSelector | object | `{}` | Node labels for the plugin-server stack deployment. |
| recordingsBlobIngestion.tolerations | list | `[]` | Toleration labels for the plugin-server stack deployment. |
| recordingsBlobIngestion.affinity | object | `{}` | Affinity settings for the plugin-server stack deployment. |
| recordingsBlobIngestion.securityContext | object | `{"enabled":false}` | Container security context for the plugin-server stack deployment. |
| recordingsBlobIngestion.podSecurityContext | object | `{"enabled":true,"fsGroup":1000}` | Pod security context for the plugin-server stack deployment. |
| recordingsBlobIngestion.livenessProbe.failureThreshold | int | `3` | The liveness probe failure threshold |
| recordingsBlobIngestion.livenessProbe.initialDelaySeconds | int | `10` | The liveness probe initial delay seconds |
| recordingsBlobIngestion.livenessProbe.periodSeconds | int | `10` | The liveness probe period seconds |
| recordingsBlobIngestion.livenessProbe.successThreshold | int | `1` | The liveness probe success threshold |
| recordingsBlobIngestion.livenessProbe.timeoutSeconds | int | `2` | The liveness probe timeout seconds |
| recordingsBlobIngestion.readinessProbe.failureThreshold | int | `3` | The readiness probe failure threshold |
| recordingsBlobIngestion.readinessProbe.initialDelaySeconds | int | `50` | The readiness probe initial delay seconds |
| recordingsBlobIngestion.readinessProbe.periodSeconds | int | `30` | The readiness probe period seconds |
| recordingsBlobIngestion.readinessProbe.successThreshold | int | `1` | The readiness probe success threshold |
| recordingsBlobIngestion.readinessProbe.timeoutSeconds | int | `5` | The readiness probe timeout seconds |
| recordingsBlobIngestion.sentryDSN | string | `nil` | Sentry endpoint to send errors to. Falls back to global sentryDSN |
| pluginsExports.enabled | bool | `false` | Whether to install the PostHog plugin-server exports capability as an individual workload. |
| pluginsExports.replicacount | int | `1` | Count of plugin-server-async pods to run. This setting is ignored if `pluginsExports.hpa.enabled` is set to `true`. |
| pluginsExports.hpa.enabled | bool | `false` | Whether to create a HorizontalPodAutoscaler for the plugin stack. |
| pluginsExports.hpa.cputhreshold | int | `60` | CPU threshold percent for the plugin-server stack HorizontalPodAutoscaler. |
| pluginsExports.hpa.minpods | int | `1` | Min pods for the plugin-server stack HorizontalPodAutoscaler. |
| pluginsExports.hpa.maxpods | int | `10` | Max pods for the plugin-server stack HorizontalPodAutoscaler. |
| pluginsExports.hpa.behavior | string | `nil` | Set the HPA behavior. See https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/ for configuration options |
| pluginsExports.rollout.maxSurge | string | `"25%"` |  |
| pluginsExports.rollout.maxUnavailable | string | `"25%"` |  |
| pluginsExports.env | list | `[]` | Additional env variables to inject into the plugin-server stack deployment. |
| pluginsExports.resources | object | `{}` | Resource limits for the plugin-server stack deployment. |
| pluginsExports.nodeSelector | object | `{}` | Node labels for the plugin-server stack deployment. |
| pluginsExports.tolerations | list | `[]` | Toleration labels for the plugin-server stack deployment. |
| pluginsExports.affinity | object | `{}` | Affinity settings for the plugin-server stack deployment. |
| pluginsExports.securityContext | object | `{"enabled":false}` | Container security context for the plugin-server stack deployment. |
| pluginsExports.podSecurityContext | object | `{"enabled":false}` | Pod security context for the plugin-server stack deployment. |
| pluginsExports.livenessProbe.failureThreshold | int | `3` | The liveness probe failure threshold |
| pluginsExports.livenessProbe.initialDelaySeconds | int | `10` | The liveness probe initial delay seconds |
| pluginsExports.livenessProbe.periodSeconds | int | `10` | The liveness probe period seconds |
| pluginsExports.livenessProbe.successThreshold | int | `1` | The liveness probe success threshold |
| pluginsExports.livenessProbe.timeoutSeconds | int | `2` | The liveness probe timeout seconds |
| pluginsExports.readinessProbe.failureThreshold | int | `3` | The readiness probe failure threshold |
| pluginsExports.readinessProbe.initialDelaySeconds | int | `50` | The readiness probe initial delay seconds |
| pluginsExports.readinessProbe.periodSeconds | int | `30` | The readiness probe period seconds |
| pluginsExports.readinessProbe.successThreshold | int | `1` | The readiness probe success threshold |
| pluginsExports.readinessProbe.timeoutSeconds | int | `5` | The readiness probe timeout seconds |
| pluginsExports.sentryDSN | string | `nil` | Sentry endpoint to send errors to. Falls back to global sentryDSN |
| pluginsJobs.enabled | bool | `false` | Whether to install the PostHog plugin-server jobs capability as an individual workload. |
| pluginsJobs.replicacount | int | `1` | Count of plugin-server-async pods to run. This setting is ignored if `pluginsJobs.hpa.enabled` is set to `true`. |
| pluginsJobs.hpa.enabled | bool | `false` | Whether to create a HorizontalPodAutoscaler for the plugin stack. |
| pluginsJobs.hpa.cputhreshold | int | `60` | CPU threshold percent for the plugin-server stack HorizontalPodAutoscaler. |
| pluginsJobs.hpa.minpods | int | `1` | Min pods for the plugin-server stack HorizontalPodAutoscaler. |
| pluginsJobs.hpa.maxpods | int | `10` | Max pods for the plugin-server stack HorizontalPodAutoscaler. |
| pluginsJobs.hpa.behavior | string | `nil` | Set the HPA behavior. See https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/ for configuration options |
| pluginsJobs.rollout.maxSurge | string | `"25%"` |  |
| pluginsJobs.rollout.maxUnavailable | string | `"25%"` |  |
| pluginsJobs.env | list | `[]` | Additional env variables to inject into the plugin-server stack deployment. |
| pluginsJobs.resources | object | `{}` | Resource limits for the plugin-server stack deployment. |
| pluginsJobs.nodeSelector | object | `{}` | Node labels for the plugin-server stack deployment. |
| pluginsJobs.tolerations | list | `[]` | Toleration labels for the plugin-server stack deployment. |
| pluginsJobs.affinity | object | `{}` | Affinity settings for the plugin-server stack deployment. |
| pluginsJobs.securityContext | object | `{"enabled":false}` | Container security context for the plugin-server stack deployment. |
| pluginsJobs.podSecurityContext | object | `{"enabled":false}` | Pod security context for the plugin-server stack deployment. |
| pluginsJobs.livenessProbe.failureThreshold | int | `3` | The liveness probe failure threshold |
| pluginsJobs.livenessProbe.initialDelaySeconds | int | `10` | The liveness probe initial delay seconds |
| pluginsJobs.livenessProbe.periodSeconds | int | `10` | The liveness probe period seconds |
| pluginsJobs.livenessProbe.successThreshold | int | `1` | The liveness probe success threshold |
| pluginsJobs.livenessProbe.timeoutSeconds | int | `2` | The liveness probe timeout seconds |
| pluginsJobs.readinessProbe.failureThreshold | int | `3` | The readiness probe failure threshold |
| pluginsJobs.readinessProbe.initialDelaySeconds | int | `50` | The readiness probe initial delay seconds |
| pluginsJobs.readinessProbe.periodSeconds | int | `30` | The readiness probe period seconds |
| pluginsJobs.readinessProbe.successThreshold | int | `1` | The readiness probe success threshold |
| pluginsJobs.readinessProbe.timeoutSeconds | int | `5` | The readiness probe timeout seconds |
| pluginsJobs.sentryDSN | string | `nil` | Sentry endpoint to send errors to. Falls back to global sentryDSN |
| pluginsScheduler.enabled | bool | `false` | Whether to install the PostHog plugin-server scheduler capability as an individual workload. |
| pluginsScheduler.replicacount | int | `1` | Count of plugin-server-async pods to run. This setting is ignored if `pluginsScheduler.hpa.enabled` is set to `true`. |
| pluginsScheduler.hpa.enabled | bool | `false` | Whether to create a HorizontalPodAutoscaler for the plugin stack. |
| pluginsScheduler.hpa.cputhreshold | int | `60` | CPU threshold percent for the plugin-server stack HorizontalPodAutoscaler. |
| pluginsScheduler.hpa.minpods | int | `1` | Min pods for the plugin-server stack HorizontalPodAutoscaler. |
| pluginsScheduler.hpa.maxpods | int | `10` | Max pods for the plugin-server stack HorizontalPodAutoscaler. |
| pluginsScheduler.hpa.behavior | string | `nil` | Set the HPA behavior. See https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/ for configuration options |
| pluginsScheduler.rollout.maxSurge | string | `"25%"` |  |
| pluginsScheduler.rollout.maxUnavailable | string | `"25%"` |  |
| pluginsScheduler.env | list | `[]` | Additional env variables to inject into the plugin-server stack deployment. |
| pluginsScheduler.resources | object | `{}` | Resource limits for the plugin-server stack deployment. |
| pluginsScheduler.nodeSelector | object | `{}` | Node labels for the plugin-server stack deployment. |
| pluginsScheduler.tolerations | list | `[]` | Toleration labels for the plugin-server stack deployment. |
| pluginsScheduler.affinity | object | `{}` | Affinity settings for the plugin-server stack deployment. |
| pluginsScheduler.securityContext | object | `{"enabled":false}` | Container security context for the plugin-server stack deployment. |
| pluginsScheduler.podSecurityContext | object | `{"enabled":false}` | Pod security context for the plugin-server stack deployment. |
| pluginsScheduler.livenessProbe.failureThreshold | int | `3` | The liveness probe failure threshold |
| pluginsScheduler.livenessProbe.initialDelaySeconds | int | `10` | The liveness probe initial delay seconds |
| pluginsScheduler.livenessProbe.periodSeconds | int | `10` | The liveness probe period seconds |
| pluginsScheduler.livenessProbe.successThreshold | int | `1` | The liveness probe success threshold |
| pluginsScheduler.livenessProbe.timeoutSeconds | int | `2` | The liveness probe timeout seconds |
| pluginsScheduler.readinessProbe.failureThreshold | int | `3` | The readiness probe failure threshold |
| pluginsScheduler.readinessProbe.initialDelaySeconds | int | `50` | The readiness probe initial delay seconds |
| pluginsScheduler.readinessProbe.periodSeconds | int | `30` | The readiness probe period seconds |
| pluginsScheduler.readinessProbe.successThreshold | int | `1` | The readiness probe success threshold |
| pluginsScheduler.readinessProbe.timeoutSeconds | int | `5` | The readiness probe timeout seconds |
| pluginsScheduler.sentryDSN | string | `nil` | Sentry endpoint to send errors to. Falls back to global sentryDSN |
| toolbox.enabled | bool | `false` | Whether to install the PostHog toolbox deployment |
| toolbox.env | list | `[]` | Additional env variables to inject into the toolbox deployment. |
| toolbox.resources | object | `{}` | Resource limits for the toolbox deployment. |
| temporalPyWorker.enabled | bool | `false` | Whether to install the PostHog Temporal Python worker stack or not. |
| temporalPyWorker.replicacount | int | `1` | Count of worker pods to run. This setting is ignored if `worker.hpa.enabled` is set to `true`. |
| temporalPyWorker.terminationGracePeriodSeconds | int | `310` | The grace period for the worker pods. This is slightly larger than the default 5 minutes of the worker by default. |
| temporalPyWorker.hpa.enabled | bool | `false` | Whether to create a HorizontalPodAutoscaler for the worker stack. |
| temporalPyWorker.hpa.cputhreshold | int | `60` | CPU threshold percent for the worker stack HorizontalPodAutoscaler. |
| temporalPyWorker.hpa.minpods | int | `1` | Min pods for the worker stack HorizontalPodAutoscaler. |
| temporalPyWorker.hpa.maxpods | int | `10` | Max pods for the worker stack HorizontalPodAutoscaler. |
| temporalPyWorker.hpa.behavior | string | `nil` | Set the HPA behavior. See https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/ for configuration options |
| temporalPyWorker.rollout.maxSurge | string | `"25%"` |  |
| temporalPyWorker.rollout.maxUnavailable | string | `"25%"` |  |
| temporalPyWorker.env | list | `[]` | Additional env variables to inject into the worker stack deployment. |
| temporalPyWorker.resources | object | `{}` | Resource limits for the worker stack deployment. |
| temporalPyWorker.nodeSelector | object | `{}` | Node labels for the worker stack deployment. |
| temporalPyWorker.tolerations | list | `[]` | Toleration labels for the worker stack deployment. |
| temporalPyWorker.affinity | object | `{}` | Affinity settings for the worker stack deployment. |
| temporalPyWorker.securityContext | object | `{"enabled":false}` | Container security context for the worker stack deployment. |
| temporalPyWorker.podSecurityContext | object | `{"enabled":false}` | Pod security context for the worker stack deployment. |
| email.host | string | `nil` | SMTP service host. |
| email.port | string | `nil` | SMTP service port. |
| email.user | string | `nil` | SMTP service user. |
| email.password | string | `nil` | SMTP service password. |
| email.existingSecret | string | `""` | Name of an existing Kubernetes secret object containing the SMTP service password. |
| email.existingSecretKey | string | `""` | Name of the key pointing to the password in your Kubernetes secret. |
| email.use_tls | bool | `true` | Use TLS to authenticate to the SMTP service. |
| email.use_ssl | string | `nil` | Use SSL to authenticate to the SMTP service. |
| email.from_email | string | `nil` | Outbound email sender to use. |
| saml.enforced | bool | `false` | Whether password-based login is disabled and users automatically redirected to SAML login. Requires SAML to be properly configured. |
| saml.disabled | bool | `false` | Whether SAML should be completely disabled. If set at build time, this will also prevent SAML dependencies from being installed. |
| saml.entity_id | string | `nil` | Entity ID from your SAML IdP. entity_id: "id-from-idp-5f9d4e-47ca-5080" |
| saml.acs_url | string | `nil` | Assertion Consumer Service URL from your SAML IdP. acs_url: "https://mysamlidp.com/saml2" |
| saml.x509_cert | string | `nil` | Public X509 certificate from your SAML IdP to validate SAML assertions x509_cert: | MIID3DCCAsSgAwIBAgIUdriHo8qmAU1I0gxsI7cFZHmna38wDQYJKoZIhvcNAQEF BQAwRTEQMA4GA1UECgwHUG9zdEhvZzEVMBMGA1UECwwMT25lTG9naW4gSWRQMRow GAYDVQQDDBFPbmVMb2dpbiBBY2NvdW50IDAeFw0yMTA4MTYyMTUyMzNaFw0yNjA4 MTYyMTUyMzNaMEUxEDAOBgNVBAoMB1Bvc3RIb2cxFTATBgNVBAsMDE9uZUxvZ2lu IElkUDEaMBgGA1UEAwwRT25lTG9naW4gQWNjb3VudCAwggEiMA0GCSqGSIb3DQEB AQUAA4IBDwAwggEKAoIBAQDEfUWFIU38ztF2EgijVsIbnlB8OIwkjZU8c34B9VwZ BQQUSxbrkuT9AX/5O27G04TBCHFZsXRId+ABSjVo8daCPu0d38Quo9KS3V3627Nw YcTYsje95lB02E/PgfiEQ6ZGCOV0P4xY9C99d26PoYTcoMT1S73jDDMOFtoD5WXG ZsKqwBks1jbLkv6RYoFBlZX00aGzOXDzUXI59/0c15KR4EzgTad0t6CU7X0HZ2Qf xGUiRb7hDLvgSby0SzpQpYUyYDnN9aSNYzpu1hiyIqrhQ7kZNy7LyGBz0UIuIImF pF6A3bzzrR4wdacFY9U0vmqFXXcepxuT5p2UyAxwbLeDAgMBAAGjgcMwgcAwDAYD VR0TAQH/BAIwADAdBgNVHQ4EFgQURLVVKanZPoXGEfYr1HmlaCEoD54wgYAGA1Ud IwR5MHeAFES1VSmp2T6FxhH2K9R5pWghKA+eoUmkRzBFMRAwDgYDVQQKDAdQb3N0 SG9nMRUwEwYDVQQLDAxPbmVMb2dpbiBJZFAxGjAYBgNVBAMMEU9uZUxvZ2luIEFj Y291bnQgghR2uIejyqYBTUjSDGwjtwVkeadrfzAOBgNVHQ8BAf8EBAMCB4AwDQYJ KoZIhvcNAQEFBQADggEBALP5lhlcV8avbnVnqO7PBtlS2mVOJ2B7obm50OaJCbRh t0I/dcNssWhT31/zmtNfKtrFicNImlKhdirApxpIp1WLEFY01a40GLmO6FG/WVvB EzwXonWP+cP8jYQnqZ15JkuHjP3DYJuOak2GqAJAfaGO67q6IkRZzRq6UwEUgNJD TlcsJAFaJDrcw07TY3mRFragdzGC7Xt/CM6r/0seY3+VBwMUMiJlvawcyQxap7om EdgmQkJA8Dk6f+geI+U7jV3orkPiofBJi9K6cp5Fd9usut8jwi3GYg2wExNGbhF4 wlMD1LOhymQGBnTXPk+000nkBnYdqEnqXzVpDiCG1Pc= |
| saml.attr_permanent_id | string | `nil` | Name of attribute that contains the permanent ID of the user in SAML assertions. attr_permanent_id: "nameID" |
| saml.attr_first_name | string | `nil` | Name of attribute that contains the first name of the user in SAML assertions. attr_first_name: "firstName" |
| saml.attr_last_name | string | `nil` | Name of attribute that contains the last name of the user in SAML assertions. attr_last_name: "lastName" |
| saml.attr_email | string | `nil` | Name of attribute that contains the email of the user in SAML assertions. attr_email: "email" |
| service.name | string | `"posthog"` | PostHog service name. |
| service.type | string | `"NodePort"` | PostHog service type. |
| service.externalPort | int | `8000` |  |
| service.internalPort | int | `8000` |  |
| service.annotations | object | `{}` | PostHog service annotations. |
| cert-manager.enabled | bool | `false` | Whether to install `cert-manager` resources. |
| cert-manager.installCRDs | bool | `true` | Whether to install `cert-manager` CRDs. |
| cert-manager.email | string | `nil` | Base default is noreply@<your-ingress-hostname> |
| cert-manager.podDnsPolicy | string | `"None"` |  |
| cert-manager.podDnsConfig.nameservers[0] | string | `"8.8.8.8"` |  |
| cert-manager.podDnsConfig.nameservers[1] | string | `"1.1.1.1"` |  |
| cert-manager.podDnsConfig.nameservers[2] | string | `"208.67.222.222"` |  |
| ingress.enabled | bool | `true` | Enable ingress controller resource |
| ingress.type | string | `nil` | Ingress handler type. Defaults to `nginx` if nginx is enabled and to `clb` on gcp. |
| ingress.hostname | string | `nil` | URL to address your PostHog installation. You will need to set up DNS after installation |
| ingress.gcp.ip_name | string | `"posthog"` | Specifies the name of the global IP address resource to be associated with the google clb |
| ingress.gcp.forceHttps | bool | `true` | If true, will force a https redirect when accessed over http |
| ingress.gcp.secretName | string | `""` | Specifies the name of the tls secret to be used by the ingress. If not specified a managed certificate will be generated. |
| ingress.letsencrypt | string | `nil` | Whether to enable letsencrypt. Defaults to true if hostname is defined and nginx and cert-manager are enabled otherwise false. |
| ingress.nginx.enabled | bool | `false` | Whether nginx is enabled |
| ingress.nginx.redirectToTLS | bool | `true` | Whether to redirect to TLS with nginx ingress. |
| ingress.annotations | object | `{}` | Extra annotations |
| ingress.secretName | string | `nil` | TLS secret to be used by the ingress. |
| ingress-nginx.controller.config.use-forwarded-headers | string | `"true"` | [ingress-nginx documentation](https://kubernetes.github.io/ingress-nginx/user-guide/nginx-configuration/configmap/#use-forwarded-headers) |
| ingress-nginx.controller.config.log-format-escape-json | string | `"true"` |  |
| ingress-nginx.controller.config.log-format-upstream | string | `"{ \"time\": \"$time_iso8601\", \"remote_addr\": \"$proxy_protocol_addr\", \"request_id\": \"$request_id\", \"correlation_id\": \"$request_id\", \"remote_user\": \"$remote_user\", \"bytes_sent\": $bytes_sent, \"request_time\": $request_time, \"status\": $status, \"host\": \"$host\", \"request_proto\": \"$server_protocol\", \"uri\": \"$uri\", \"request_query\": \"$args\", \"request_length\": $request_length, \"duration\": $request_time, \"method\": \"$request_method\", \"http_referrer\": \"$http_referer\", \"http_user_agent\": \"$http_user_agent\", \"http_x_forwarded_for\": \"$http_x_forwarded_for\" }"` |  |
| ingress-nginx.controller.proxySetHeaders.X-Correlation-ID | string | `"$request_id"` |  |
| postgresql.enabled | bool | `true` | Whether to deploy a PostgreSQL server to satisfy the applications requirements. To use an external PostgreSQL instance set this to `false` and configure the `externalPostgresql` parameters. |
| postgresql.nameOverride | string | `"posthog-postgresql"` | Name override for PostgreSQL app. |
| postgresql.postgresqlDatabase | string | `"posthog"` | PostgreSQL database name. |
| postgresql.postgresqlPassword | string | `"postgres"` | PostgreSQL database password. |
| postgresql.persistence.enabled | bool | `true` | Enable persistence using PVC. |
| postgresql.persistence.size | string | `"10Gi"` | PVC Storage Request for PostgreSQL volume. |
| externalPostgresql.postgresqlHost | string | `nil` | External PostgreSQL service host. |
| externalPostgresql.postgresqlPort | int | `5432` | External PostgreSQL service port. |
| externalPostgresql.postgresqlDatabase | string | `nil` | External PostgreSQL service database name. |
| externalPostgresql.postgresqlUsername | string | `nil` | External PostgreSQL service user. |
| externalPostgresql.postgresqlPassword | string | `nil` | External PostgreSQL service password. Either this or `externalPostgresql.existingSecret` must be set. |
| externalPostgresql.existingSecret | string | `nil` | Name of an existing Kubernetes secret object containing the PostgreSQL password |
| externalPostgresql.existingSecretPasswordKey | string | `"postgresql-password"` | Name of the key pointing to the password in your Kubernetes secret |
| _pgbouncer.enabled | bool | `true` | Whether to deploy a PgBouncer service to satisfy the applications requirements. |
| _pgbouncer.exporter.enabled | bool | `false` | Whether to install a Prometheus export as a sidecar |
| _pgbouncer.exporter.port | int | `9127` |  |
| _pgbouncer.exporter.image.repository | string | `"prometheuscommunity/pgbouncer-exporter"` |  |
| _pgbouncer.exporter.image.tag | string | `"v0.4.1"` |  |
| _pgbouncer.exporter.image.pullPolicy | string | `"IfNotPresent"` |  |
| _pgbouncer.exporter.image.pullSecrets | list | `[]` |  |
| _pgbouncer.exporter.resources | object | `{}` | Resource limits for pgbouncer-exporter. |
| _pgbouncer.exporter.securityContext | object | `{"enabled":false}` | Container security context for pgbouncer-exporter. |
| _pgbouncer.replicacount | int | `1` | Count of pgbouncer pods to run. This setting is ignored if `pgbouncer.hpa.enabled` is set to `true`. |
| _pgbouncer.hpa.enabled | bool | `false` | Whether to create a HorizontalPodAutoscaler for the pgbouncer stack. |
| _pgbouncer.hpa.cputhreshold | int | `60` | CPU threshold percent for the pgbouncer stack HorizontalPodAutoscaler. |
| _pgbouncer.hpa.minpods | int | `1` | Min pods for the pgbouncer stack HorizontalPodAutoscaler. |
| _pgbouncer.hpa.maxpods | int | `10` | Max pods for the pgbouncer stack HorizontalPodAutoscaler. |
| _pgbouncer.hpa.behavior | string | `nil` | Set the HPA behavior. See https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/ for configuration options |
| _pgbouncer.env | list | `[{"name":"PGBOUNCER_PORT","value":"6543"},{"name":"PGBOUNCER_MAX_CLIENT_CONN","value":"1000"},{"name":"PGBOUNCER_POOL_MODE","value":"transaction"},{"name":"PGBOUNCER_IGNORE_STARTUP_PARAMETERS","value":"extra_float_digits"}]` | Additional env variables to inject into the pgbouncer stack deployment. |
| _pgbouncer.resources | object | `{}` | Resource limits for the pgbouncer stack deployment. |
| _pgbouncer.nodeSelector | object | `{}` | Node labels for the pgbouncer stack deployment. |
| _pgbouncer.tolerations | list | `[]` | Toleration labels for the pgbouncer stack deployment. |
| _pgbouncer.affinity | object | `{}` | Affinity settings for the pgbouncer stack deployment. |
| _pgbouncer.securityContext | object | `{"enabled":false}` | Container security context for the pgbouncer stack deployment. |
| _pgbouncer.podSecurityContext | object | `{"enabled":false}` | Pod security context for the pgbouncer stack deployment. |
| _pgbouncer.readinessProbe.failureThreshold | int | `3` | The readiness probe failure threshold |
| _pgbouncer.readinessProbe.initialDelaySeconds | int | `10` | The readiness probe initial delay seconds |
| _pgbouncer.readinessProbe.periodSeconds | int | `5` | The readiness probe period seconds |
| _pgbouncer.readinessProbe.successThreshold | int | `1` | The readiness probe success threshold |
| _pgbouncer.readinessProbe.timeoutSeconds | int | `2` | The readiness probe timeout seconds |
| _pgbouncer.livenessProbe.failureThreshold | int | `3` | The liveness probe failure threshold |
| _pgbouncer.livenessProbe.initialDelaySeconds | int | `60` | The liveness probe initial delay seconds |
| _pgbouncer.livenessProbe.periodSeconds | int | `10` | The liveness probe period seconds |
| _pgbouncer.livenessProbe.successThreshold | int | `1` | The liveness probe success threshold |
| _pgbouncer.livenessProbe.timeoutSeconds | int | `2` | The liveness probe timeout seconds |
| _pgbouncer.image.repository | string | `"bitnami/pgbouncer"` |  |
| _pgbouncer.image.tag | string | `"1.18.0"` |  |
| _pgbouncer.image.pullPolicy | string | `"IfNotPresent"` |  |
| _pgbouncer.image.pullSecrets | list | `[]` |  |
| _pgbouncer.service.type | string | `"ClusterIP"` |  |
| _pgbouncer.service.annotations | object | `{}` |  |
| _pgbouncer.podAnnotations | object | `{}` |  |
| pgbouncer.<<.enabled | bool | `true` | Whether to deploy a PgBouncer service to satisfy the applications requirements. |
| pgbouncer.<<.exporter.enabled | bool | `false` | Whether to install a Prometheus export as a sidecar |
| pgbouncer.<<.exporter.port | int | `9127` |  |
| pgbouncer.<<.exporter.image.repository | string | `"prometheuscommunity/pgbouncer-exporter"` |  |
| pgbouncer.<<.exporter.image.tag | string | `"v0.4.1"` |  |
| pgbouncer.<<.exporter.image.pullPolicy | string | `"IfNotPresent"` |  |
| pgbouncer.<<.exporter.image.pullSecrets | list | `[]` |  |
| pgbouncer.<<.exporter.resources | object | `{}` | Resource limits for pgbouncer-exporter. |
| pgbouncer.<<.exporter.securityContext | object | `{"enabled":false}` | Container security context for pgbouncer-exporter. |
| pgbouncer.<<.replicacount | int | `1` | Count of pgbouncer pods to run. This setting is ignored if `pgbouncer.hpa.enabled` is set to `true`. |
| pgbouncer.<<.hpa.enabled | bool | `false` | Whether to create a HorizontalPodAutoscaler for the pgbouncer stack. |
| pgbouncer.<<.hpa.cputhreshold | int | `60` | CPU threshold percent for the pgbouncer stack HorizontalPodAutoscaler. |
| pgbouncer.<<.hpa.minpods | int | `1` | Min pods for the pgbouncer stack HorizontalPodAutoscaler. |
| pgbouncer.<<.hpa.maxpods | int | `10` | Max pods for the pgbouncer stack HorizontalPodAutoscaler. |
| pgbouncer.<<.hpa.behavior | string | `nil` | Set the HPA behavior. See https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/ for configuration options |
| pgbouncer.<<.env | list | `[{"name":"PGBOUNCER_PORT","value":"6543"},{"name":"PGBOUNCER_MAX_CLIENT_CONN","value":"1000"},{"name":"PGBOUNCER_POOL_MODE","value":"transaction"},{"name":"PGBOUNCER_IGNORE_STARTUP_PARAMETERS","value":"extra_float_digits"}]` | Additional env variables to inject into the pgbouncer stack deployment. |
| pgbouncer.<<.resources | object | `{}` | Resource limits for the pgbouncer stack deployment. |
| pgbouncer.<<.nodeSelector | object | `{}` | Node labels for the pgbouncer stack deployment. |
| pgbouncer.<<.tolerations | list | `[]` | Toleration labels for the pgbouncer stack deployment. |
| pgbouncer.<<.affinity | object | `{}` | Affinity settings for the pgbouncer stack deployment. |
| pgbouncer.<<.securityContext | object | `{"enabled":false}` | Container security context for the pgbouncer stack deployment. |
| pgbouncer.<<.podSecurityContext | object | `{"enabled":false}` | Pod security context for the pgbouncer stack deployment. |
| pgbouncer.<<.readinessProbe.failureThreshold | int | `3` | The readiness probe failure threshold |
| pgbouncer.<<.readinessProbe.initialDelaySeconds | int | `10` | The readiness probe initial delay seconds |
| pgbouncer.<<.readinessProbe.periodSeconds | int | `5` | The readiness probe period seconds |
| pgbouncer.<<.readinessProbe.successThreshold | int | `1` | The readiness probe success threshold |
| pgbouncer.<<.readinessProbe.timeoutSeconds | int | `2` | The readiness probe timeout seconds |
| pgbouncer.<<.livenessProbe.failureThreshold | int | `3` | The liveness probe failure threshold |
| pgbouncer.<<.livenessProbe.initialDelaySeconds | int | `60` | The liveness probe initial delay seconds |
| pgbouncer.<<.livenessProbe.periodSeconds | int | `10` | The liveness probe period seconds |
| pgbouncer.<<.livenessProbe.successThreshold | int | `1` | The liveness probe success threshold |
| pgbouncer.<<.livenessProbe.timeoutSeconds | int | `2` | The liveness probe timeout seconds |
| pgbouncer.<<.image.repository | string | `"bitnami/pgbouncer"` |  |
| pgbouncer.<<.image.tag | string | `"1.18.0"` |  |
| pgbouncer.<<.image.pullPolicy | string | `"IfNotPresent"` |  |
| pgbouncer.<<.image.pullSecrets | list | `[]` |  |
| pgbouncer.<<.service.type | string | `"ClusterIP"` |  |
| pgbouncer.<<.service.annotations | object | `{}` |  |
| pgbouncer.<<.podAnnotations | object | `{}` |  |
| pgbouncer.fqdn | string | `""` |  |
| pgbouncerRead.<<.enabled | bool | `true` | Whether to deploy a PgBouncer service to satisfy the applications requirements. |
| pgbouncerRead.<<.exporter.enabled | bool | `false` | Whether to install a Prometheus export as a sidecar |
| pgbouncerRead.<<.exporter.port | int | `9127` |  |
| pgbouncerRead.<<.exporter.image.repository | string | `"prometheuscommunity/pgbouncer-exporter"` |  |
| pgbouncerRead.<<.exporter.image.tag | string | `"v0.4.1"` |  |
| pgbouncerRead.<<.exporter.image.pullPolicy | string | `"IfNotPresent"` |  |
| pgbouncerRead.<<.exporter.image.pullSecrets | list | `[]` |  |
| pgbouncerRead.<<.exporter.resources | object | `{}` | Resource limits for pgbouncer-exporter. |
| pgbouncerRead.<<.exporter.securityContext | object | `{"enabled":false}` | Container security context for pgbouncer-exporter. |
| pgbouncerRead.<<.replicacount | int | `1` | Count of pgbouncer pods to run. This setting is ignored if `pgbouncer.hpa.enabled` is set to `true`. |
| pgbouncerRead.<<.hpa.enabled | bool | `false` | Whether to create a HorizontalPodAutoscaler for the pgbouncer stack. |
| pgbouncerRead.<<.hpa.cputhreshold | int | `60` | CPU threshold percent for the pgbouncer stack HorizontalPodAutoscaler. |
| pgbouncerRead.<<.hpa.minpods | int | `1` | Min pods for the pgbouncer stack HorizontalPodAutoscaler. |
| pgbouncerRead.<<.hpa.maxpods | int | `10` | Max pods for the pgbouncer stack HorizontalPodAutoscaler. |
| pgbouncerRead.<<.hpa.behavior | string | `nil` | Set the HPA behavior. See https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/ for configuration options |
| pgbouncerRead.<<.env | list | `[{"name":"PGBOUNCER_PORT","value":"6543"},{"name":"PGBOUNCER_MAX_CLIENT_CONN","value":"1000"},{"name":"PGBOUNCER_POOL_MODE","value":"transaction"},{"name":"PGBOUNCER_IGNORE_STARTUP_PARAMETERS","value":"extra_float_digits"}]` | Additional env variables to inject into the pgbouncer stack deployment. |
| pgbouncerRead.<<.resources | object | `{}` | Resource limits for the pgbouncer stack deployment. |
| pgbouncerRead.<<.nodeSelector | object | `{}` | Node labels for the pgbouncer stack deployment. |
| pgbouncerRead.<<.tolerations | list | `[]` | Toleration labels for the pgbouncer stack deployment. |
| pgbouncerRead.<<.affinity | object | `{}` | Affinity settings for the pgbouncer stack deployment. |
| pgbouncerRead.<<.securityContext | object | `{"enabled":false}` | Container security context for the pgbouncer stack deployment. |
| pgbouncerRead.<<.podSecurityContext | object | `{"enabled":false}` | Pod security context for the pgbouncer stack deployment. |
| pgbouncerRead.<<.readinessProbe.failureThreshold | int | `3` | The readiness probe failure threshold |
| pgbouncerRead.<<.readinessProbe.initialDelaySeconds | int | `10` | The readiness probe initial delay seconds |
| pgbouncerRead.<<.readinessProbe.periodSeconds | int | `5` | The readiness probe period seconds |
| pgbouncerRead.<<.readinessProbe.successThreshold | int | `1` | The readiness probe success threshold |
| pgbouncerRead.<<.readinessProbe.timeoutSeconds | int | `2` | The readiness probe timeout seconds |
| pgbouncerRead.<<.livenessProbe.failureThreshold | int | `3` | The liveness probe failure threshold |
| pgbouncerRead.<<.livenessProbe.initialDelaySeconds | int | `60` | The liveness probe initial delay seconds |
| pgbouncerRead.<<.livenessProbe.periodSeconds | int | `10` | The liveness probe period seconds |
| pgbouncerRead.<<.livenessProbe.successThreshold | int | `1` | The liveness probe success threshold |
| pgbouncerRead.<<.livenessProbe.timeoutSeconds | int | `2` | The liveness probe timeout seconds |
| pgbouncerRead.<<.image.repository | string | `"bitnami/pgbouncer"` |  |
| pgbouncerRead.<<.image.tag | string | `"1.18.0"` |  |
| pgbouncerRead.<<.image.pullPolicy | string | `"IfNotPresent"` |  |
| pgbouncerRead.<<.image.pullSecrets | list | `[]` |  |
| pgbouncerRead.<<.service.type | string | `"ClusterIP"` |  |
| pgbouncerRead.<<.service.annotations | object | `{}` |  |
| pgbouncerRead.<<.podAnnotations | object | `{}` |  |
| pgbouncerRead.host | string | `""` |  |
| pgbouncerRead.fqdn | string | `""` |  |
| pgbouncerRead.enabled | bool | `false` |  |
| redis.enabled | bool | `true` | Whether to deploy a Redis server to satisfy the applications requirements. To use an external redis instance set this to `false` and configure the `externalRedis` parameters. |
| redis.nameOverride | string | `"posthog-redis"` |  |
| redis.fullnameOverride | string | `""` |  |
| redis.architecture | string | `"standalone"` |  |
| redis.auth.enabled | bool | `false` | Enable Redis password authentication. |
| redis.auth.password | string | `""` | Redis password.    Defaults to a random 10-character alphanumeric string if not set.    NOTE: ignored unless `redis.auth.enabled` is `true` or if `redis.auth.existingSecret` is set. |
| redis.auth.existingSecret | string | `""` | The name of an existing secret containing the Redis credential to use.    NOTE: ignored unless `redis.auth.enabled` is `true`.          When it is set, the previous `redis.auth.password` parameter is ignored. |
| redis.auth.existingSecretPasswordKey | string | `""` | Password key to be retrieved from existing secret.    NOTE: ignored unless `redis.auth.existingSecret` parameter is set. |
| redis.master.persistence.enabled | bool | `true` | Enable data persistence using PVC. |
| redis.master.persistence.size | string | `"5Gi"` | Persistent Volume size. |
| redis.master.extraFlags | list | `["--maxmemory 400mb","--maxmemory-policy allkeys-lru"]` | Array with additional command line flags for Redis master. |
| externalRedis.host | string | `""` | External Redis host to use. |
| externalRedis.port | int | `6379` | External Redis port to use. |
| externalRedis.password | string | `""` | Password for the external Redis. Ignored if `externalRedis.existingSecret` is set. |
| externalRedis.existingSecret | string | `""` | Name of an existing Kubernetes secret object containing the Redis password. |
| externalRedis.existingSecretPasswordKey | string | `""` | Name of the key pointing to the password in your Kubernetes secret. |
| externalSessionRecordingRedis | object | `{}` |  |
| kafka.enabled | bool | `true` | Whether to deploy Kafka as part of this release. To use an external Kafka instance set this to `false` and configure the `externalKafka` values. |
| kafka.nameOverride | string | `"posthog-kafka"` |  |
| kafka.fullnameOverride | string | `""` |  |
| kafka.logRetentionBytes | string | `"_15_000_000_000"` | A size-based retention policy for logs. |
| kafka.logRetentionHours | int | `24` | The minimum age of a log file to be eligible for deletion due to age. |
| kafka.numPartitions | int | `1` | The default number of log partitions per topic. |
| kafka.persistence.enabled | bool | `true` |  |
| kafka.persistence.size | string | `"20Gi"` | PVC Storage Request for Kafka data volume. |
| kafka.zookeeper.enabled | bool | `false` | Switch to enable or disable the ZooKeeper helm chart. !!! Please DO NOT override this (this chart installs Zookeeper separately) !!! |
| kafka.externalZookeeper.servers | list | `["posthog-posthog-zookeeper:2181"]` | List of external zookeeper servers to use. |
| externalKafka.brokers | list | `[]` |  |
| externalKafka.tls | bool | `false` |  |
| externalSessionRecordingKafka.brokers | list | `[]` |  |
| externalSessionRecordingKafka.tls | bool | `false` |  |
| externalTemporal.host | string | `""` |  |
| externalTemporal.port | int | `7233` |  |
| externalTemporal.namespace | string | `""` |  |
| zookeeper.enabled | bool | `true` | Whether to deploy Zookeeper as part of this release. |
| zookeeper.nameOverride | string | `"posthog-zookeeper"` |  |
| zookeeper.replicaCount | int | `1` | Number of ZooKeeper nodes |
| zookeeper.autopurge.purgeInterval | int | `1` | The time interval (in hours) for which the purge task has to be triggered |
| zookeeper.metrics.enabled | bool | `false` | Enable Prometheus to access ZooKeeper metrics endpoint. |
| zookeeper.metrics.service.annotations."prometheus.io/scrape" | string | `"false"` |  |
| zookeeper.podAnnotations | string | `nil` |  |
| clickhouse.enabled | bool | `true` | Whether to install clickhouse. If false, `clickhouse.host` must be set |
| clickhouse.namespace | string | `nil` | Which namespace to install clickhouse and the `clickhouse-operator` to (defaults to namespace chart is installed to) |
| clickhouse.cluster | string | `"posthog"` | Clickhouse cluster |
| clickhouse.database | string | `"posthog"` | Clickhouse database |
| clickhouse.user | string | `"admin"` | Clickhouse user |
| clickhouse.password | string | `"a1f31e03-c88e-4ca6-a2df-ad49183d15d9"` | Clickhouse password |
| clickhouse.existingSecret | string | `""` | Clickhouse existing secret name that needs to be in the namespace where posthog is deployed into. Will not use the above password value if set |
| clickhouse.existingSecretPasswordKey | string | `""` | Key in the existingSecret containing the password value |
| clickhouse.secure | bool | `false` | Whether to use TLS connection connecting to ClickHouse |
| clickhouse.verify | bool | `false` | Whether to verify TLS certificate on connection to ClickHouse |
| clickhouse.image.repository | string | `"clickhouse/clickhouse-server"` | ClickHouse image repository. |
| clickhouse.image.tag | string | `"23.9.2.56"` | ClickHouse image tag. Note: PostHog does not support all versions of ClickHouse. Please override the default only if you know what you are doing. |
| clickhouse.image.pullPolicy | string | `"IfNotPresent"` | Image pull policy |
| clickhouse.image.pullSecrets | list | `[]` |  |
| clickhouse.tolerations | list | `[]` | Toleration labels for clickhouse pod assignment |
| clickhouse.affinity | object | `{}` | Affinity settings for clickhouse pod |
| clickhouse.resources | object | `{}` | Clickhouse resource requests/limits. See more at http://kubernetes.io/docs/user-guide/compute-resources/ |
| clickhouse.securityContext.enabled | bool | `true` |  |
| clickhouse.securityContext.runAsUser | int | `101` |  |
| clickhouse.securityContext.runAsGroup | int | `101` |  |
| clickhouse.securityContext.fsGroup | int | `101` |  |
| clickhouse.serviceType | string | `"ClusterIP"` | Kubernetes Service type. |
| clickhouse.allowedNetworkIps | list | `["10.0.0.0/8","172.16.0.0/12","192.168.0.0/16"]` | An allowlist of IP addresses or network masks the ClickHouse user is allowed to access from. By default anything within a private network will be allowed. This should suffice for most use case although to expose to other networks you will need to update this setting. For more details on usage, see https://posthog.com/docs/self-host/deploy/configuration#securing-clickhouse |
| clickhouse.persistence.enabled | bool | `true` | Enable data persistence using PVC. |
| clickhouse.persistence.existingClaim | string | `""` | Use a manually managed Persistent Volume and Claim.    If defined, PVC must be created manually before volume will be bound. |
| clickhouse.persistence.storageClass | string | `nil` | Persistent Volume Storage Class to use.    If defined, `storageClassName: <storageClass>`.    If set to `storageClassName: ""`, disables dynamic provisioning.    If undefined (the default) or set to `null`, no storageClassName spec is    set, choosing the default provisioner. |
| clickhouse.persistence.size | string | `"20Gi"` | Persistent Volume size |
| clickhouse.profiles | object | `{}` |  |
| clickhouse.defaultProfiles.default/allow_experimental_window_functions | string | `"1"` |  |
| clickhouse.defaultProfiles.default/allow_nondeterministic_mutations | string | `"1"` |  |
| clickhouse.layout.shardsCount | int | `1` |  |
| clickhouse.layout.replicasCount | int | `1` |  |
| clickhouse.settings | object | `{}` |  |
| clickhouse.defaultSettings.default_database | string | `"posthog"` |  |
| clickhouse.defaultSettings.format_schema_path | string | `"/etc/clickhouse-server/config.d/"` |  |
| clickhouse.additionalUsersConfig | string | `nil` |  |
| clickhouse.podAnnotations | string | `nil` |  |
| clickhouse.podDistribution | string | `nil` |  |
| clickhouse.client.image.repository | string | `"clickhouse/clickhouse-server"` | ClickHouse image repository. |
| clickhouse.client.image.tag | string | `"23.9.2.56"` | ClickHouse image tag. Note: PostHog does not support all versions of ClickHouse. Please override the default only if you know what you are doing. |
| clickhouse.client.image.pullPolicy | string | `"IfNotPresent"` | Image pull policy |
| clickhouse.client.image.pullSecrets | list | `[]` |  |
| clickhouse.backup.enabled | bool | `false` |  |
| clickhouse.backup.image.repository | string | `"altinity/clickhouse-backup"` | Clickhouse backup image repository. |
| clickhouse.backup.image.tag | string | `"1.5.0"` | ClickHouse backup image tag. |
| clickhouse.backup.image.pullPolicy | string | `"IfNotPresent"` | Image pull policy |
| clickhouse.backup.image.pullSecrets | list | `[]` |  |
| clickhouse.backup.backup_user | string | `"backup"` |  |
| clickhouse.backup.backup_password | string | `"backup_password"` |  |
| clickhouse.backup.existingSecret | string | `""` | Use an existing secret name in the deployed namespace for the backup password |
| clickhouse.backup.existingSecretPasswordKey | string | `""` | Key in the existingSecret containing the password value |
| clickhouse.backup.backup_schedule | string | `"0 0 * * *"` |  |
| clickhouse.backup.clickhouse_services | string | `"chi-posthog-posthog-0-0"` |  |
| clickhouse.backup.env[0].name | string | `"LOG_LEVEL"` |  |
| clickhouse.backup.env[0].value | string | `"debug"` |  |
| clickhouse.backup.env[1].name | string | `"ALLOW_EMPTY_BACKUPS"` |  |
| clickhouse.backup.env[1].value | string | `"true"` |  |
| clickhouse.backup.env[2].name | string | `"API_LISTEN"` |  |
| clickhouse.backup.env[2].value | string | `"0.0.0.0:7171"` |  |
| clickhouse.backup.env[3].name | string | `"API_CREATE_INTEGRATION_TABLES"` |  |
| clickhouse.backup.env[3].value | string | `"true"` |  |
| clickhouse.backup.env[4].name | string | `"BACKUPS_TO_KEEP_REMOTE"` |  |
| clickhouse.backup.env[4].value | string | `"0"` |  |
| externalClickhouse.host | string | `nil` | Host of the external cluster. This is required when clickhouse.enabled is false |
| externalClickhouse.cluster | string | `nil` | Name of the external cluster to run DDL queries on. This is required when clickhouse.enabled is false |
| externalClickhouse.database | string | `"posthog"` | Database name for the external cluster |
| externalClickhouse.user | string | `nil` | User name for the external cluster to connect to the external cluster as |
| externalClickhouse.password | string | `nil` | Password for the cluster. Ignored if existingClickhouse.existingSecret is set |
| externalClickhouse.existingSecret | string | `nil` | Name of an existing Kubernetes secret object containing the password |
| externalClickhouse.existingSecretPasswordKey | string | `nil` | Name of the key pointing to the password in your Kubernetes secret |
| externalClickhouse.secure | bool | `false` | Whether to use TLS connection connecting to ClickHouse |
| externalClickhouse.verify | bool | `false` | Whether to verify TLS connection connecting to ClickHouse |
| cloudwatch.enabled | bool | `false` | Enable cloudwatch container insights to get logs and metrics on AWS |
| cloudwatch.region | string | `nil` | AWS region |
| cloudwatch.clusterName | string | `nil` | AWS EKS cluster name |
| cloudwatch.fluentBit | object | `{"port":2020,"readHead":"On","readTail":"Off","server":"On"}` | fluentBit configuration |
| hooks.nodeSelector | object | `{}` | Node labels for hooks. |
| hooks.tolerations | list | `[]` | Toleration labels for hooks. |
| hooks.affinity | object | `{}` | Affinity settings for hooks. |
| hooks.migrate.env | list | `[]` | Env variables for migate hooks |
| hooks.migrate.resources | object | `{}` | Hook job resource limits/requests |
| serviceAccount.create | bool | `true` | Configures if a ServiceAccount with this name should be created |
| serviceAccount.name | string | `nil` | name of the ServiceAccount to be used by access-controlled resources. @default autogenerated |
| serviceAccount.annotations | object | `{}` | Configures annotation for the ServiceAccount |
| minio.enabled | bool | `false` | Whether to install MinIO (object storage system) or not. You can keep it disabled or rely on `externalObjectStorage` if you want to use a managed object storage service (AWS S3, Google Cloud Storage, ...). |
| minio.auth.rootUser | string | `"root-user"` | MinIO root username |
| minio.auth.rootPassword | string | `"root-password-change-me-please"` | MinIO root password |
| minio.auth.existingSecret | string | `nil` | Use existing secret for credentials details (`auth.rootUser` and `auth.rootPassword` will be ignored and picked up from this secret). The secret has to contain the keys `root-user` and `root-password`) |
| minio.persistence.enabled | bool | `true` | Enable MinIO data persistence using PVC. |
| minio.defaultBuckets | string | `"posthog"` | Comma, semi-colon or space separated list of buckets to create at initialization (only in standalone mode) |
| minio.disableWebUI | bool | `true` | Disable MinIO Web UI |
| minio.service.ports.api | string | `"19000"` | MinIO API service port |
| minio.service.ports.console | string | `"19001"` | MinIO Console service port |
| minio.podAnnotations | string | `nil` |  |
| externalObjectStorage.endpoint | string | `nil` | Endpoint of the external object storage. e.g. https://s3.us-east-1.amazonaws.com |
| externalObjectStorage.host | string | `nil` | Host of the external object storage. Deprecated: use endpoint instead |
| externalObjectStorage.port | string | `nil` | Port of the external object storage. Deprecated: use endpoint instead |
| externalObjectStorage.bucket | string | `nil` | Bucket name to use. |
| externalObjectStorage.region | string | `nil` | Region of the bucket (for AWS). |
| externalObjectStorage.existingSecret | string | `nil` | Name of an existing Kubernetes secret object containing the `access_key_id` and `secret_access_key`. The secret has to contain the keys `root-user` and `root-password`). |
| grafana.enabled | bool | `false` | Whether to install Grafana or not. |
| grafana.sidecar | object | `{"dashboards":{"enabled":true,"folderAnnotation":"grafana_folder","label":"grafana_dashboard","provider":{"foldersFromFilesStructure":true}}}` | Sidecar configuration to automagically pull the dashboards from the `charts/posthog/grafana-dashboard` folder. See [official docs](https://github.com/grafana/helm-charts/blob/main/charts/grafana/README.md) for more info. |
| grafana.datasources | object | `{"datasources.yaml":{"apiVersion":1,"datasources":[{"access":"proxy","isDefault":true,"jsonData":{"timeInterval":"60s"},"name":"Prometheus","type":"prometheus","url":"http://posthog-prometheus-server"},{"access":"proxy","isDefault":false,"name":"Loki","type":"loki","url":"http://posthog-loki-read:3100"},{"access":"proxy","isDefault":false,"jsonData":{"implementation":"prometheus"},"name":"Alertmanager","type":"alertmanager","url":"http://posthog-prometheus-alertmanager"}]}}` | Configure Grafana datasources. See [docs](http://docs.grafana.org/administration/provisioning/#datasources) for more info. |
| loki.enabled | bool | `false` | Whether to install Loki or not. With the default configuration you will get no replication, so as to easily support small deploys that e.g. do not have multiple nodes in the cluster. For production setups that are distributed across e.g. multiple AWS AZs it's recommended that you increase the replica counts for `read:` and `write:`. These stateful sets by default have an anti-affinity so you'll need at least as many nodes as replicas in a set. |
| loki.loki.auth_enabled | bool | `false` |  |
| loki.loki.commonConfig.replication_factor | int | `1` |  |
| loki.loki.podAnnotations | object | `{}` |  |
| loki.read.replicas | int | `1` |  |
| loki.write.replicas | int | `1` |  |
| loki.gateway.enabled | bool | `false` |  |
| loki.minio.enabled | bool | `true` | Whether to enable minio as backing storage for Loki. To use S3 or GCS instead, set this to false and specify the appropriate `loki.storage` configuration. Note if you do use minio in production, the default setup is minimal and will only run with 1 replica. In production setups it's recommended change minio settings to your needs. |
| loki.minio.replicas | int | `1` |  |
| loki.minio.drivesPerNode | int | `2` |  |
| loki.fullnameOverride | string | `"posthog-loki"` |  |
| loki.nameOverride | string | `"posthog-loki"` |  |
| loki.monitoring.alerts.enabled | bool | `false` |  |
| loki.monitoring.dashboards.enabled | bool | `false` |  |
| loki.monitoring.rules.enabled | bool | `false` |  |
| loki.monitoring.selfMonitoring.enabled | bool | `false` |  |
| loki.monitoring.selfMonitoring.grafanaAgent.installOperator | bool | `false` |  |
| loki.monitoring.selfMonitoring.lokiCanary.enabled | bool | `false` |  |
| loki.monitoring.serviceMonitor.enabled | bool | `false` |  |
| loki.test.enabled | bool | `false` |  |
| eventrouter.enabled | bool | `false` | Whether to install eventrouter. |
| eventrouter.image.repository | string | `"gcr.io/heptio-images/eventrouter"` |  |
| eventrouter.image.tag | string | `"v0.3"` |  |
| eventrouter.image.pullPolicy | string | `"IfNotPresent"` |  |
| eventrouter.image.pullSecrets | list | `[]` |  |
| eventrouter.resources | object | `{}` | Resource limits for eventrouter. |
| promtail.enabled | bool | `false` | Whether to install Promtail or not. |
| promtail.config.clients[0].url | string | `"http://posthog-loki-write:3100/loki/api/v1/push"` |  |
| promtail.config.snippets.pipelineStages[0].cri | object | `{}` |  |
| promtail.config.snippets.pipelineStages[1].match.selector | string | `"{app=\"ingress-nginx\"}"` |  |
| promtail.config.snippets.pipelineStages[1].match.stages[0].json.expressions.timestamp | string | `"time"` |  |
| promtail.config.snippets.pipelineStages[1].match.stages[0].json.expressions.host | string | `"host"` |  |
| promtail.config.snippets.pipelineStages[1].match.stages[0].json.expressions.method | string | `"method"` |  |
| promtail.config.snippets.pipelineStages[1].match.stages[0].json.expressions.uri | string | `"uri"` |  |
| promtail.config.snippets.pipelineStages[1].match.stages[0].json.expressions.status | string | `"status"` |  |
| promtail.config.snippets.pipelineStages[1].match.stages[0].json.expressions.user_agent | string | `"http_user_agent"` |  |
| promtail.config.snippets.pipelineStages[1].match.stages[0].json.expressions.correlation_id | string | `"correlation_id"` |  |
| promtail.config.snippets.pipelineStages[1].match.stages[0].json.expressions.forwarded_for | string | `"http_x_forwarded_for"` |  |
| promtail.config.snippets.pipelineStages[1].match.stages[1].labels.method | string | `nil` |  |
| promtail.config.snippets.pipelineStages[1].match.stages[1].labels.status | string | `nil` |  |
| promtail.config.snippets.pipelineStages[1].match.stages[2].timestamp.source | string | `"timestamp"` |  |
| promtail.config.snippets.pipelineStages[1].match.stages[2].timestamp.format | string | `"RFC3339"` |  |
| promtail.config.snippets.pipelineStages[2].match.selector | string | `"{app=\"posthog\", container=~\"posthog-web|posthog-worker|posthog-events\"}"` |  |
| promtail.config.snippets.pipelineStages[2].match.stages[0].json.expressions.timestamp | string | `nil` |  |
| promtail.config.snippets.pipelineStages[2].match.stages[0].json.expressions.level | string | `nil` |  |
| promtail.config.snippets.pipelineStages[2].match.stages[1].labels.level | string | `nil` |  |
| promtail.config.snippets.pipelineStages[2].match.stages[2].timestamp.source | string | `"timestamp"` |  |
| promtail.config.snippets.pipelineStages[2].match.stages[2].timestamp.format | string | `"RFC3339Nano"` |  |
| promtail.podAnnotations | object | `{}` |  |
| prometheus.enabled | bool | `false` | Whether to install Prometheus or not. |
| prometheus.alertmanager.enabled | bool | `false` | Whether to install Prometheus AlertManager or not. |
| prometheus.alertmanager.podAnnotations | object | `{}` |  |
| prometheus.pushgateway.enabled | bool | `false` | Whether to install Prometheus Pushgateway or not. |
| prometheus.serverFiles."alerting_rules.yml" | object | `{"groups":[{"name":"PostHog","rules":[{"alert":"IngestionOverflowProduction","annotations":{"description":"Due to some scenario such as many events from a single distinct_id, we have pushed some events to the ingestion overflow topic so we can keed up with events from other users. Check partition stats for how many events we've received for each distinct_id or team_id, or look in ClickHouse for any recent trends for distinct_ids.","summary":"Ingestion has pushed events to the overflow topic for\n10 minutes.\n"},"expr":"sum(\n  delta(\n    kafka_topic_partition_current_offset{\n      topic=\"events_plugin_ingestion_overflow\"\n    }[1m]\n  )\n) > 0\n","for":"10m","labels":{"rotation":"common","severity":"warning"}},{"alert":"IngestionOverflowConsumerLag","annotations":{"description":"Lag on the ingestion topic is increasing. Check that the\nconsumer for the topic is running. Also check the production\nrate to the topic to see if there is an unusually high volume\ngoing to it.\n","summary":"Ingestion lag on the Overflow topic has been increasing over the past 10 minutes.\n"},"expr":"sum(\n  delta(\n    kafka_consumergroup_lag{\n      topic='events_plugin_ingestion_overflow', consumergroup=\"clickhouse-ingestion-overflow\"\n    }[2m]\n  )\n) > 0\n","for":"10m","labels":{"rotation":"common","severity":"warning"}},{"alert":"DjangoErrorRate","annotations":{"description":"Django reports a high error rate (5xx status codes) on role {{ $labels.role }}.\nCheck the \"Exceptions\" widget in the \"HTTP by application endpoint\" dashboard and the pod logs to\nidentify the issue. Either a dependency is unhealthy, or a recent code change triggered a bug and\nneeds to be rolled-back.\n","summary":"Django error rate exceeds 2% on role {{ $labels.role }}"},"expr":"sum by (role) (increase(django_http_responses_total_by_status_view_method_total{status=~\"^5.*\"}[5m])) /\nsum by (role) (increase(django_http_responses_total_by_status_view_method_total[5m])) > 0.02\n","for":"5m","labels":{"rotation":"common","severity":"critical"}},{"alert":"End2EndIngestionLag","annotations":{"description":"Our end-to-end probe measured an ingestion lag higher than 20 minutes for scenario {{ $labels.scenario }}.\nCheck the \"Kafka (cluster overview)\" dashboard to identify what topics and partitions are lagging and\nfollow the https://posthog.com/docs/runbook/services/plugin-server/ingestion-lag runbook for recovery\nsteps.\n","summary":"End-to-end analytics event ingestion lag exceeds 20 minutes for more than 5 minutes."},"expr":"(max by(scenario) (posthog_celery_observed_ingestion_lag_seconds{scenario=~\"ingestion_api|ingestion\"})) > 1200","for":"5m","labels":{"rotation":"common","severity":"critical"}},{"alert":"ExportsConsumerDelayed","annotations":{"description":"Latest timestamp registered as processed on topic 'clickhouse_events_json', consumer group 'async_handlers' more then 5 minutes old","summary":"Exports and WebHooks have delayed by more than 5 minutes for more than 5 minutes."},"expr":"(time() * 1000 - (max(latest_processed_timestamp_ms{groupId=\"async_handlers\",topic=\"clickhouse_events_json\"}))) > 300000","for":"5m","labels":{"rotation":"common","severity":"critical"}},{"alert":"ScheduledTasksConsumerDelayed","annotations":{"description":"Latest timestamp registered as processed on topic 'scheduled_tasks', consumer group 'scheduled-tasks-runner' more then 5 minutes old","summary":"RunEveryX tasks have been delayed by more than 5 minutes for more than 5 minutes."},"expr":"(time() * 1000 - (max(latest_processed_timestamp_ms{groupId=\"scheduled-tasks-runner\",topic=\"scheduled_tasks\"}))) > 300000","for":"10m","labels":{"rotation":"common","severity":"critical"}},{"alert":"JobsConsumerDelayed","annotations":{"description":"Latest timestamp registered as processed on topic 'jobs', consumer group 'jobs-inserter' more then 5 minutes old.\nCheck https://github.com/PostHog/product-internal/blob/main/infrastructure/runbooks/pipeline/graphile.md\nfor more context and steps to recovery.\n","runbook_url":"https://github.com/PostHog/product-internal/blob/main/infrastructure/runbooks/pipeline/graphile.md","summary":"Jobs scheduled via Apps jobs have been delayed by more than 5 minutes for more than 5 minutes."},"expr":"(time() * 1000 - (max(latest_processed_timestamp_ms{groupId=\"jobs-inserter\",topic=\"jobs\"}))) > 300000","for":"10m","labels":{"rotation":"common","severity":"critical"}},{"alert":"IngestionConsumerDelayed","annotations":{"description":"Latest timestamp registered as processed on topic 'events_plugin_ingestion', consumer group 'ingestion' more then 5 minutes old","summary":"Ingestion for analytics events has been delayed by more than 5 minutes for more than 5 minutes."},"expr":"(time() * 1000 - (max(latest_processed_timestamp_ms{groupId=\"ingestion\",topic=\"events_plugin_ingestion\"}))) > 300000","for":"5m","labels":{"rotation":"common","severity":"critical"}},{"alert":"RecordingsConsumerDelayed","annotations":{"description":"Latest timestamp registered as processed on topic 'session_recording_events', consumer group 'session-recordings' more then 5 minutes old","summary":"Ingestion for session recording and web performance events has been delayed by more than 5 minutes for more than 5 minutes."},"expr":"(time() * 1000 - (max(latest_processed_timestamp_ms{groupId=\"session-recordings\",topic=\"session_recording_events\"}))) > 300000","for":"5m","labels":{"rotation":"common","severity":"critical"}},{"alert":"RecordingsConsumerDLQ","annotations":{"description":"The `session_recording_events_dlq` topic offset has increased over the past 5 minutes.","summary":"Failed to process some session recording events and have been sent to the dead letter queue for review."},"expr":"sum(delta(kafka_topic_partition_current_offset{topic=\"session_recording_events_dlq\"}[5m])) > 0","for":"1m","labels":{"rotation":"common","severity":"critical"}},{"alert":"GraphileJobExecutionLag","annotations":{"description":"Jobs of type {{ $labels.task_identifier }} have been sitting in the Graphile execution queue for more\nthan 5 minutes, possibly delaying apps and/or exports.\nCheck https://github.com/PostHog/product-internal/blob/main/infrastructure/runbooks/pipeline/graphile.md\nfor more context and steps to recovery.\n","runbook_url":"https://github.com/PostHog/product-internal/blob/main/infrastructure/runbooks/pipeline/graphile.md","summary":"Graphile jobs execution lag exceeds 15 minutes for more than 5 minutes."},"expr":"(max by(task_identifier) (posthog_celery_graphile_lag_seconds{task_identifier!=\"bufferJob\"})) > 900","for":"5m","labels":{"rotation":"common","severity":"critical"}},{"alert":"CeleryQueueDepth","annotations":{"description":"The Celery jobs queue (stored in Redis) is filling up faster than it is consumed. This impacts our\nmonitoring, as some paging monitors depend on metrics exported by Celery jobs.\n  - make sure posthog-worker pods are healthy and check their logs\n  - look for recent code changes to posthog/celery.py and rollback if needed\n  - check the health of Postgres and Clickhouse, many jobs query them and could hang if these\n    stores get slow\n","summary":"Celery job execution delayed for more than 60 minutes."},"expr":"(max (posthog_celery_queue_depth)) > 1000","for":"60m","labels":{"rotation":"common","severity":"critical"}},{"alert":"KafkaDiskCritical","annotations":{"description":"Kafka disks are getting full and should be upscaled before we lose new events.\nWe should upscale the disks, or (as a last-ditch option) lower the data retention\nto free up disk space.\n","summary":"Less than 500GB free on Kafka broker(s)"},"expr":"min by (instance) (aws_msk_node_filesystem_free_bytes{mountpoint=\"/kafka/datalogs\"}) < 536870912000","for":"2m","labels":{"rotation":"common","severity":"critical"}},{"alert":"KafkaDiskCapacityPlanning","annotations":{"description":"Kafka disks are getting full and should be upscaled before we lose new events.\nIf not handled, the KafkaDiskCritical will page the common rotation at 500GB.\n","summary":"Less than 1TB free on Kafka broker(s)"},"expr":"min by (instance) (aws_msk_node_filesystem_free_bytes{mountpoint=\"/kafka/datalogs\"}) < 1036870912000","for":"2m","labels":{"rotation":"infra","severity":"warning"}}]},{"name":"Kubernetes","rules":[{"alert":"KubernetesNodeReady","annotations":{"description":"Node {{ $labels.node }} has been unready for a long time","summary":"Kubernetes Node ready (instance {{ $labels.instance }})"},"expr":"kube_node_status_condition{condition=\"Ready\",status=\"true\"} == 0","for":"10m","labels":{"severity":"critical"}},{"alert":"KubernetesMemoryPressure","annotations":{"description":"{{ $labels.node }} has MemoryPressure condition","summary":"Kubernetes memory pressure (instance {{ $labels.instance }})"},"expr":"kube_node_status_condition{condition=\"MemoryPressure\",status=\"true\"} == 1","for":"2m","labels":{"severity":"critical"}},{"alert":"KubernetesDiskPressure","annotations":{"description":"{{ $labels.node }} has DiskPressure condition","summary":"Kubernetes disk pressure (instance {{ $labels.instance }})"},"expr":"kube_node_status_condition{condition=\"DiskPressure\",status=\"true\"} == 1","for":"10m","labels":{"severity":"critical"}},{"alert":"KubernetesOutOfDisk","annotations":{"description":"{{ $labels.node }} has OutOfDisk condition","summary":"Kubernetes out of disk (instance {{ $labels.instance }})"},"expr":"kube_node_status_condition{condition=\"OutOfDisk\",status=\"true\"} == 1","for":"2m","labels":{"severity":"critical"}},{"alert":"KubernetesOutOfCapacity","annotations":{"description":"{{ $labels.node }} is out of capacity","summary":"Kubernetes out of capacity (instance {{ $labels.instance }})"},"expr":"sum by (node) ((kube_pod_status_phase{phase=\"Running\"} == 1) + on(uid) group_left(node) (0 * kube_pod_info{pod_template_hash=\"\"})) / sum by (node) (kube_node_status_allocatable{resource=\"pods\"}) * 100 > 90","for":"2m","labels":{"severity":"critical"}},{"alert":"KubernetesContainerOomKiller","annotations":{"description":"Container {{ $labels.container }} in pod {{ $labels.namespace }}/{{ $labels.pod }} has been OOMKilled {{ $value }} times in the last 10 minutes.","summary":"Kubernetes container oom killer (instance {{ $labels.instance }})"},"expr":"(kube_pod_container_status_restarts_total - kube_pod_container_status_restarts_total offset 10m >= 1) and ignoring (reason) min_over_time(kube_pod_container_status_last_terminated_reason{reason=\"OOMKilled\"}[10m]) == 1","for":"0m","labels":{"severity":"critical"}},{"alert":"KubernetesJobFailed","annotations":{"description":"Job {{$labels.namespace}}/{{$labels.exported_job}} failed to complete","summary":"Kubernetes Job failed (instance {{ $labels.instance }})"},"expr":"kube_job_status_failed > 0","for":"0m","labels":{"severity":"warning"}},{"alert":"KubernetesCronjobSuspended","annotations":{"description":"CronJob {{ $labels.namespace }}/{{ $labels.cronjob }} is suspended","summary":"Kubernetes CronJob suspended (instance {{ $labels.instance }})"},"expr":"kube_cronjob_spec_suspend != 0","for":"0m","labels":{"severity":"warning"}},{"alert":"KubernetesPersistentvolumeclaimPending","annotations":{"description":"PersistentVolumeClaim {{ $labels.namespace }}/{{ $labels.persistentvolumeclaim }} is pending","summary":"Kubernetes PersistentVolumeClaim pending (instance {{ $labels.instance }})"},"expr":"kube_persistentvolumeclaim_status_phase{phase=\"Pending\"} == 1","for":"2m","labels":{"severity":"warning"}},{"alert":"KubernetesVolumeOutOfDiskSpace","annotations":{"description":"Volume is almost full (< 10% left)","summary":"Kubernetes Volume out of disk space (instance {{ $labels.instance }})"},"expr":"kubelet_volume_stats_available_bytes / kubelet_volume_stats_capacity_bytes * 100 < 10","for":"2m","labels":{"severity":"critical"}},{"alert":"KubernetesVolumeFullInFourDays","annotations":{"description":"{{ $labels.namespace }}/{{ $labels.persistentvolumeclaim }} is expected to fill up within four days. Currently {{ $value | humanize }}% is available.","summary":"Kubernetes Volume full in four days (instance {{ $labels.instance }})"},"expr":"predict_linear(kubelet_volume_stats_available_bytes[6h], 4 * 24 * 3600) < 0","for":"0m","labels":{"severity":"critical"}},{"alert":"KubernetesPersistentvolumeError","annotations":{"description":"Persistent volume is in bad state","summary":"Kubernetes PersistentVolume error (instance {{ $labels.instance }})"},"expr":"kube_persistentvolume_status_phase{phase=~\"Failed|Pending\", job=\"kube-state-metrics\"} > 0","for":"0m","labels":{"severity":"critical"}},{"alert":"KubernetesStatefulsetDown","annotations":{"description":"A StatefulSet went down","summary":"Kubernetes StatefulSet down (instance {{ $labels.instance }})"},"expr":"(kube_statefulset_status_replicas_ready / kube_statefulset_status_replicas_current) != 1","for":"1m","labels":{"severity":"critical"}},{"alert":"KubernetesHpaScalingAbility","annotations":{"description":"Pod is unable to scale","summary":"Kubernetes HPA scaling ability (instance {{ $labels.instance }})"},"expr":"kube_horizontalpodautoscaler_status_condition{status=\"false\", condition=\"AbleToScale\"} == 1","for":"2m","labels":{"severity":"critical"}},{"alert":"KubernetesHpaMetricAvailability","annotations":{"description":"HPA is not able to collect metrics","summary":"Kubernetes HPA metric availability (instance {{ $labels.instance }})"},"expr":"kube_horizontalpodautoscaler_status_condition{status=\"false\", condition=\"ScalingActive\"} == 1","for":"5m","labels":{"severity":"critical"}},{"alert":"KubernetesHpaScaleCapability","annotations":{"description":"The maximum number of desired Pods has been hit","summary":"Kubernetes HPA scale capability (instance {{ $labels.instance }})"},"expr":"kube_horizontalpodautoscaler_status_desired_replicas >= kube_horizontalpodautoscaler_spec_max_replicas","for":"2m","labels":{"severity":"critical"}},{"alert":"KubernetesPodNotHealthy","annotations":{"description":"Pod has been in a non-ready state for longer than 15 minutes.","summary":"Kubernetes Pod not healthy (instance {{ $labels.instance }})"},"expr":"sum by (namespace, pod) (kube_pod_status_phase{phase=~\"Pending|Unknown|Failed\"}) > 0","for":"15m","labels":{"severity":"warning"}},{"alert":"KubernetesPodCrashLooping","annotations":{"description":"Pod {{ $labels.pod }} is crash looping","summary":"Kubernetes pod crash looping (instance {{ $labels.instance }})"},"expr":"increase(kube_pod_container_status_restarts_total[1m]) > 3","for":"2m","labels":{"severity":"warning"}},{"alert":"KubernetesReplicassetMismatch","annotations":{"description":"The number of ready pods in the Deployment's replicaset does not match the desired number.\n","summary":"Kubernetes ReplicasSet mismatch (instance {{ $labels.instance }})"},"expr":"kube_replicaset_spec_replicas != kube_replicaset_status_ready_replicas","for":"10m","labels":{"severity":"warning"}},{"alert":"KubernetesDeploymentReplicasMismatch","annotations":{"description":"The number of ready pods in the Deployment does not match the desired number.\n","summary":"Kubernetes Deployment replicas mismatch (instance {{ $labels.instance }})"},"expr":"kube_deployment_spec_replicas != kube_deployment_status_replicas_available","for":"10m","labels":{"severity":"warning"}},{"alert":"KubernetesStatefulsetReplicasMismatch","annotations":{"description":"The number of ready pods in the StatefulSet does not match the desired number.\n","summary":"Kubernetes StatefulSet replicas mismatch (instance {{ $labels.instance }})"},"expr":"kube_statefulset_status_replicas_ready != kube_statefulset_status_replicas","for":"10m","labels":{"severity":"warning"}},{"alert":"KubernetesDeploymentGenerationMismatch","annotations":{"description":"A Deployment has failed but has not been rolled back.","summary":"Kubernetes Deployment generation mismatch (instance {{ $labels.instance }})"},"expr":"kube_deployment_status_observed_generation != kube_deployment_metadata_generation","for":"10m","labels":{"severity":"critical"}},{"alert":"KubernetesStatefulsetGenerationMismatch","annotations":{"description":"A StatefulSet has failed but has not been rolled back.","summary":"Kubernetes StatefulSet generation mismatch (instance {{ $labels.instance }})"},"expr":"kube_statefulset_status_observed_generation != kube_statefulset_metadata_generation","for":"10m","labels":{"severity":"critical"}},{"alert":"KubernetesStatefulsetUpdateNotRolledOut","annotations":{"description":"StatefulSet update has not been rolled out.","summary":"Kubernetes StatefulSet update not rolled out (instance {{ $labels.instance }})"},"expr":"max without (revision) (kube_statefulset_status_current_revision unless kube_statefulset_status_update_revision) * (kube_statefulset_replicas != kube_statefulset_status_replicas_updated)","for":"10m","labels":{"severity":"warning"}},{"alert":"KubernetesDaemonsetRolloutStuck","annotations":{"description":"Some Pods of DaemonSet are not scheduled or not ready","summary":"Kubernetes DaemonSet rollout stuck (instance {{ $labels.instance }})"},"expr":"kube_daemonset_status_number_ready / kube_daemonset_status_desired_number_scheduled * 100 < 100 or kube_daemonset_status_desired_number_scheduled - kube_daemonset_status_current_number_scheduled > 0","for":"10m","labels":{"severity":"warning"}},{"alert":"KubernetesDaemonsetMisscheduled","annotations":{"description":"Some DaemonSet Pods are running where they are not supposed to run","summary":"Kubernetes DaemonSet misscheduled (instance {{ $labels.instance }})"},"expr":"kube_daemonset_status_number_misscheduled > 0","for":"5m","labels":{"severity":"critical"}},{"alert":"KubernetesCronjobTooLong","annotations":{"description":"CronJob {{ $labels.namespace }}/{{ $labels.cronjob }} is taking more than 1h to complete.","summary":"Kubernetes CronJob too long (instance {{ $labels.instance }})"},"expr":"time() - kube_cronjob_next_schedule_time > 3600","for":"0m","labels":{"severity":"warning"}},{"alert":"KubernetesJobSlowCompletion","annotations":{"description":"Kubernetes Job {{ $labels.namespace }}/{{ $labels.job_name }} did not complete in time.","summary":"Kubernetes job slow completion (instance {{ $labels.instance }})"},"expr":"kube_job_spec_completions - kube_job_status_succeeded > 0","for":"12h","labels":{"severity":"critical"}},{"alert":"KubernetesApiServerErrors","annotations":{"description":"Kubernetes API server is experiencing high error rate","summary":"Kubernetes API server errors (instance {{ $labels.instance }})"},"expr":"sum(rate(apiserver_request_total{job=\"apiserver\",code=~\"^(?:5..)$\"}[1m])) / sum(rate(apiserver_request_total{job=\"apiserver\"}[1m])) * 100 > 3","for":"2m","labels":{"severity":"critical"}},{"alert":"KubernetesApiClientErrors","annotations":{"description":"Kubernetes API client is experiencing high error rate","summary":"Kubernetes API client errors (instance {{ $labels.instance }})"},"expr":"(sum(rate(rest_client_requests_total{code=~\"(4|5)..\"}[1m])) by (instance, job) / sum(rate(rest_client_requests_total[1m])) by (instance, job)) * 100 > 1","for":"2m","labels":{"severity":"critical"}},{"alert":"KubernetesClientCertificateExpiresNextWeek","annotations":{"description":"A client certificate used to authenticate to the apiserver is expiring next week.","summary":"Kubernetes client certificate expires next week (instance {{ $labels.instance }})"},"expr":"apiserver_client_certificate_expiration_seconds_count{job=\"apiserver\"} > 0 and histogram_quantile(0.01, sum by (job, le) (rate(apiserver_client_certificate_expiration_seconds_bucket{job=\"apiserver\"}[5m]))) < 7*24*60*60","for":"0m","labels":{"severity":"warning"}},{"alert":"KubernetesClientCertificateExpiresSoon","annotations":{"description":"A client certificate used to authenticate to the apiserver is expiring in less than 24.0 hours.","summary":"Kubernetes client certificate expires soon (instance {{ $labels.instance }})"},"expr":"apiserver_client_certificate_expiration_seconds_count{job=\"apiserver\"} > 0 and histogram_quantile(0.01, sum by (job, le) (rate(apiserver_client_certificate_expiration_seconds_bucket{job=\"apiserver\"}[5m]))) < 24*60*60","for":"0m","labels":{"severity":"critical"}},{"alert":"KubernetesApiServerLatency","annotations":{"description":"Kubernetes API server has a 99th percentile latency of {{ $value }} seconds for {{ $labels.verb }} {{ $labels.resource }}.","summary":"Kubernetes API server latency (instance {{ $labels.instance }})"},"expr":"histogram_quantile(0.99, sum(rate(apiserver_request_latencies_bucket{subresource!=\"log\",verb!~\"^(?:CONNECT|WATCHLIST|WATCH|PROXY)$\"} [10m])) WITHOUT (instance, resource)) / 1e+06 > 1","for":"2m","labels":{"severity":"warning"}}]},{"name":"Loki","rules":[{"alert":"LokiProcessTooManyRestarts","annotations":{"description":"A loki process had too many restarts (target {{ $labels.instance }})","summary":"Loki process too many restarts (instance {{ $labels.instance }})"},"expr":"changes(process_start_time_seconds{app=\"loki\"}[15m]) > 2","for":"0m","labels":{"severity":"warning"}},{"alert":"LokiRequestErrors","annotations":{"description":"The {{ $labels.job }} and {{ $labels.route }} are experiencing errors","summary":"Loki request errors (instance {{ $labels.instance }})"},"expr":"100 * sum(rate(loki_request_duration_seconds_count{status_code=~\"5..\"}[1m])) by (namespace, job, route) / sum(rate(loki_request_duration_seconds_count[1m])) by (namespace, job, route) > 10","for":"15m","labels":{"severity":"warning"}},{"alert":"LokiRequestPanic","annotations":{"description":"The {{ $labels.job }} is experiencing {{ printf \"%.2f\" $value }}% increase of panics","summary":"Loki request panic (instance {{ $labels.instance }})"},"expr":"sum(increase(loki_panic_total[10m])) by (namespace, job) > 0","for":"5m","labels":{"severity":"warning"}},{"alert":"LokiRequestLatency","annotations":{"description":"The {{ $labels.job }} {{ $labels.route }} is experiencing {{ printf \"%.2f\" $value }}s 99th percentile latency","summary":"Loki request latency (instance {{ $labels.instance }})"},"expr":"(histogram_quantile(0.99, sum(rate(loki_request_duration_seconds_bucket{route!~\"(?i).*tail.*\"}[5m])) by (le))) > 3","for":"10m","labels":{"severity":"warning"}}]},{"name":"Promtail","rules":[{"alert":"PromtailRequestErrors","annotations":{"description":"The {{ $labels.job }} {{ $labels.route }} is experiencing {{ printf \"%.2f\" $value }}% errors.","summary":"Promtail request errors (instance {{ $labels.instance }})"},"expr":"100 * sum(rate(promtail_request_duration_seconds_count{status_code=~\"5..|failed\"}[1m])) by (namespace, job, route, instance) / sum(rate(promtail_request_duration_seconds_count[1m])) by (namespace, job, route, instance) > 10","for":"5m","labels":{"severity":"critical"}},{"alert":"PromtailRequestLatency","annotations":{"description":"The {{ $labels.job }} {{ $labels.route }} is experiencing {{ printf \"%.2f\" $value }}s 99th percentile latency.","summary":"Promtail request latency (instance {{ $labels.instance }})"},"expr":"histogram_quantile(0.99, sum(rate(promtail_request_duration_seconds_bucket[5m])) by (le)) > 1","for":"5m","labels":{"severity":"critical"}}]},{"name":"Prometheus","rules":[{"alert":"PrometheusJobMissing","annotations":{"description":"A Prometheus job has disappeared","summary":"Prometheus job missing (instance {{ $labels.instance }})"},"expr":"absent(up{job=\"prometheus\"})","for":"0m","labels":{"severity":"warning"}},{"alert":"PrometheusTargetMissing","annotations":{"description":"A Prometheus target has disappeared. An exporter might be crashed.","summary":"Prometheus target missing (instance {{ $labels.instance }})"},"expr":"up == 0","for":"5m","labels":{"severity":"critical"}},{"alert":"PrometheusAllTargetsMissing","annotations":{"description":"A Prometheus job does not have living target anymore.","summary":"Prometheus all targets missing (instance {{ $labels.instance }})"},"expr":"sum by (job) (up) == 0","for":"0m","labels":{"severity":"critical"}},{"alert":"PrometheusConfigurationReloadFailure","annotations":{"description":"Prometheus configuration reload error","summary":"Prometheus configuration reload failure (instance {{ $labels.instance }})"},"expr":"prometheus_config_last_reload_successful != 1","for":"0m","labels":{"severity":"critical"}},{"alert":"PrometheusTooManyRestarts","annotations":{"description":"Prometheus has restarted more than twice in the last 15 minutes. It might be crashlooping.","summary":"Prometheus too many restarts (instance {{ $labels.instance }})"},"expr":"changes(process_start_time_seconds{job=~\"prometheus|pushgateway|alertmanager\"}[15m]) > 2","for":"0m","labels":{"severity":"critical"}},{"alert":"PrometheusAlertmanagerJobMissing","annotations":{"description":"A Prometheus AlertManager job has disappeared","summary":"Prometheus AlertManager job missing (instance {{ $labels.instance }})"},"expr":"absent(up{job=\"kubernetes-pods\", app=\"prometheus\", component=\"alertmanager\"})","for":"0m","labels":{"severity":"critical"}},{"alert":"PrometheusAlertmanagerConfigurationReloadFailure","annotations":{"description":"AlertManager configuration reload error","summary":"Prometheus AlertManager configuration reload failure (instance {{ $labels.instance }})"},"expr":"alertmanager_config_last_reload_successful != 1","for":"0m","labels":{"severity":"critical"}},{"alert":"PrometheusAlertmanagerConfigNotSynced","annotations":{"description":"Configurations of AlertManager cluster instances are out of sync","summary":"Prometheus AlertManager config not synced (instance {{ $labels.instance }})"},"expr":"count(count_values(\"config_hash\", alertmanager_config_hash)) > 1","for":"0m","labels":{"severity":"critical"}},{"alert":"PrometheusAlertmanagerE2eDeadManSwitch","annotations":{"description":"Prometheus DeadManSwitch is an always-firing alert. It's used as an end-to-end test of Prometheus through the Alertmanager.","summary":"Prometheus AlertManager E2E dead man switch (instance {{ $labels.instance }})"},"expr":"vector(1)","for":"0m","labels":{"severity":"critical"}},{"alert":"PrometheusNotConnectedToAlertmanager","annotations":{"description":"Prometheus cannot connect the alertmanager","summary":"Prometheus not connected to alertmanager (instance {{ $labels.instance }})"},"expr":"prometheus_notifications_alertmanagers_discovered < 1","for":"0m","labels":{"severity":"critical"}},{"alert":"PrometheusRuleEvaluationFailures","annotations":{"description":"Prometheus encountered {{ $value }} rule evaluation failures, leading to potentially ignored alerts.","summary":"Prometheus rule evaluation failures (instance {{ $labels.instance }})"},"expr":"increase(prometheus_rule_evaluation_failures_total[3m]) > 0","for":"0m","labels":{"severity":"critical"}},{"alert":"PrometheusTemplateTextExpansionFailures","annotations":{"description":"Prometheus encountered {{ $value }} template text expansion failures","summary":"Prometheus template text expansion failures (instance {{ $labels.instance }})"},"expr":"increase(prometheus_template_text_expansion_failures_total[3m]) > 0","for":"0m","labels":{"severity":"critical"}},{"alert":"PrometheusRuleEvaluationSlow","annotations":{"description":"Prometheus rule evaluation took more time than the scheduled interval. It indicates a slower storage backend access or too complex query.","summary":"Prometheus rule evaluation slow (instance {{ $labels.instance }})"},"expr":"prometheus_rule_group_last_duration_seconds > prometheus_rule_group_interval_seconds","for":"5m","labels":{"severity":"warning"}},{"alert":"PrometheusNotificationsBacklog","annotations":{"description":"The Prometheus notification queue has not been empty for 10 minutes","summary":"Prometheus notifications backlog (instance {{ $labels.instance }})"},"expr":"min_over_time(prometheus_notifications_queue_length[10m]) > 0","for":"0m","labels":{"severity":"warning"}},{"alert":"PrometheusAlertmanagerNotificationFailing","annotations":{"description":"Alertmanager is failing sending notifications","summary":"Prometheus AlertManager notification failing (instance {{ $labels.instance }})"},"expr":"rate(alertmanager_notifications_failed_total[1m]) > 0","for":"0m","labels":{"severity":"critical"}},{"alert":"PrometheusTargetEmpty","annotations":{"description":"Prometheus has no target in service discovery","summary":"Prometheus target empty (instance {{ $labels.instance }})"},"expr":"prometheus_sd_discovered_targets == 0","for":"0m","labels":{"severity":"critical"}},{"alert":"PrometheusTargetScrapingSlow","annotations":{"description":"Prometheus is scraping exporters slowly since it exceeded the requested interval time. Your Prometheus server is under-provisioned.","summary":"Prometheus target scraping slow (instance {{ $labels.instance }})"},"expr":"prometheus_target_interval_length_seconds{quantile=\"0.9\"} / on (interval, instance, job) prometheus_target_interval_length_seconds{quantile=\"0.5\"} > 1.05","for":"5m","labels":{"severity":"warning"}},{"alert":"PrometheusLargeScrape","annotations":{"description":"Prometheus has many scrapes that exceed the sample limit","summary":"Prometheus large scrape (instance {{ $labels.instance }})"},"expr":"increase(prometheus_target_scrapes_exceeded_sample_limit_total[10m]) > 10","for":"5m","labels":{"severity":"warning"}},{"alert":"PrometheusTargetScrapeDuplicate","annotations":{"description":"Prometheus has many samples rejected due to duplicate timestamps but different values","summary":"Prometheus target scrape duplicate (instance {{ $labels.instance }})"},"expr":"increase(prometheus_target_scrapes_sample_duplicate_timestamp_total[5m]) > 0","for":"0m","labels":{"severity":"warning"}},{"alert":"PrometheusTsdbCheckpointCreationFailures","annotations":{"description":"Prometheus encountered {{ $value }} checkpoint creation failures","summary":"Prometheus TSDB checkpoint creation failures (instance {{ $labels.instance }})"},"expr":"increase(prometheus_tsdb_checkpoint_creations_failed_total[1m]) > 0","for":"0m","labels":{"severity":"critical"}},{"alert":"PrometheusTsdbCheckpointDeletionFailures","annotations":{"description":"Prometheus encountered {{ $value }} checkpoint deletion failures","summary":"Prometheus TSDB checkpoint deletion failures (instance {{ $labels.instance }})"},"expr":"increase(prometheus_tsdb_checkpoint_deletions_failed_total[1m]) > 0","for":"0m","labels":{"severity":"critical"}},{"alert":"PrometheusTsdbCompactionsFailed","annotations":{"description":"Prometheus encountered {{ $value }} TSDB compactions failures","summary":"Prometheus TSDB compactions failed (instance {{ $labels.instance }})"},"expr":"increase(prometheus_tsdb_compactions_failed_total[1m]) > 0","for":"0m","labels":{"severity":"critical"}},{"alert":"PrometheusTsdbHeadTruncationsFailed","annotations":{"description":"Prometheus encountered {{ $value }} TSDB head truncation failures","summary":"Prometheus TSDB head truncations failed (instance {{ $labels.instance }})"},"expr":"increase(prometheus_tsdb_head_truncations_failed_total[1m]) > 0","for":"0m","labels":{"severity":"critical"}},{"alert":"PrometheusTsdbReloadFailures","annotations":{"description":"Prometheus encountered {{ $value }} TSDB reload failures","summary":"Prometheus TSDB reload failures (instance {{ $labels.instance }})"},"expr":"increase(prometheus_tsdb_reloads_failures_total[1m]) > 0","for":"0m","labels":{"severity":"critical"}},{"alert":"PrometheusTsdbWalCorruptions","annotations":{"description":"Prometheus encountered {{ $value }} TSDB WAL corruptions","summary":"Prometheus TSDB WAL corruptions (instance {{ $labels.instance }})"},"expr":"increase(prometheus_tsdb_wal_corruptions_total[1m]) > 0","for":"0m","labels":{"severity":"critical"}},{"alert":"PrometheusTsdbWalTruncationsFailed","annotations":{"description":"Prometheus encountered {{ $value }} TSDB WAL truncation failures","summary":"Prometheus TSDB WAL truncations failed (instance {{ $labels.instance }})"},"expr":"increase(prometheus_tsdb_wal_truncations_failed_total[1m]) > 0","for":"0m","labels":{"severity":"critical"}}]},{"name":"Redis","rules":[{"alert":"RedisDown","annotations":{"description":"Redis instance is down","summary":"Redis down (instance {{ $labels.instance }})"},"expr":"redis_up == 0","for":"0m","labels":{"severity":"critical"}},{"alert":"RedisMissingMaster","annotations":{"description":"Redis cluster has no node marked as master.","summary":"Redis missing master (instance {{ $labels.instance }})"},"expr":"(count(redis_instance_info{role=\"master\"}) or vector(0)) < 1","for":"0m","labels":{"severity":"critical"}},{"alert":"RedisTooManyMasters","annotations":{"description":"Redis cluster has too many nodes marked as master.","summary":"Redis too many masters (instance {{ $labels.instance }})"},"expr":"count(redis_instance_info{role=\"master\"}) > 1","for":"0m","labels":{"severity":"critical"}},{"alert":"RedisDisconnectedSlaves","annotations":{"description":"Redis not replicating for all slaves. Consider reviewing the redis replication status.","summary":"Redis disconnected slaves (instance {{ $labels.instance }})"},"expr":"count without (instance, job) (redis_connected_slaves) - sum without (instance, job) (redis_connected_slaves) - 1 > 1","for":"0m","labels":{"severity":"critical"}},{"alert":"RedisReplicationBroken","annotations":{"description":"Redis instance lost a slave","summary":"Redis replication broken (instance {{ $labels.instance }})"},"expr":"delta(redis_connected_slaves[1m]) < 0","for":"0m","labels":{"severity":"critical"}},{"alert":"RedisClusterFlapping","annotations":{"description":"Changes have been detected in Redis replica connection. This can occur when replica nodes lose connection to the master and reconnect (a.k.a flapping).","summary":"Redis cluster flapping (instance {{ $labels.instance }})"},"expr":"changes(redis_connected_slaves[1m]) > 1","for":"2m","labels":{"severity":"critical"}},{"alert":"RedisMissingBackup","annotations":{"description":"Redis has not been backuped for 24 hours","summary":"Redis missing backup (instance {{ $labels.instance }})"},"expr":"time() - redis_rdb_last_save_timestamp_seconds > 60 * 60 * 24","for":"0m","labels":{"severity":"critical"}},{"alert":"RedisOutOfSystemMemory","annotations":{"description":"Redis is running out of system memory (> 90%)","summary":"Redis out of system memory (instance {{ $labels.instance }})"},"expr":"redis_memory_used_bytes / redis_total_system_memory_bytes * 100 > 90","for":"2m","labels":{"severity":"warning"}},{"alert":"RedisOutOfConfiguredMaxmemory","annotations":{"description":"Redis is running out of configured maxmemory (> 90%)","summary":"Redis out of configured maxmemory (instance {{ $labels.instance }})"},"expr":"redis_memory_used_bytes / redis_memory_max_bytes * 100 > 90","for":"2m","labels":{"severity":"warning"}},{"alert":"RedisTooManyConnections","annotations":{"description":"Redis instance has too many connections","summary":"Redis too many connections (instance {{ $labels.instance }})"},"expr":"redis_connected_clients > 100","for":"2m","labels":{"severity":"warning"}},{"alert":"RedisNotEnoughConnections","annotations":{"description":"Redis instance should have more connections (> 5)","summary":"Redis not enough connections (instance {{ $labels.instance }})"},"expr":"redis_connected_clients < 5","for":"2m","labels":{"severity":"warning"}},{"alert":"RedisRejectedConnections","annotations":{"description":"Some connections to Redis has been rejected","summary":"Redis rejected connections (instance {{ $labels.instance }})"},"expr":"increase(redis_rejected_connections_total[1m]) > 0","for":"0m","labels":{"severity":"critical"}}]}]}` | Please consider to explicitly override this input in your `values.yaml` if you need to keep it stable. |
| prometheus-pushgateway.enabled | bool | `false` | Whether to install the `prometheus-pushgateway` or not. |
| prometheus-pushgateway.podAnnotations | object | `{"prometheus.io/path":"/metrics","prometheus.io/port":"9091","prometheus.io/scrape":"true"}` | Map of annotations to add to the pods. |
| external-prometheus-pushgateway.enabled | bool | `false` | Whether to enable the external `prometheus-pushgateway` or not. |
| external-prometheus-pushgateway.address | string | `"prometheus-pushgateway:9091"` | Address to the external `prometheus-pushgateway` |
| prometheus-statsd-exporter.enabled | bool | `false` | Whether to install the `prometheus-statsd-exporter` or not. |
| prometheus-statsd-exporter.podAnnotations | object | `{"prometheus.io/path":"/metrics","prometheus.io/port":"9102","prometheus.io/scrape":"true"}` | Map of annotations to add to the pods. |
| externalStatsd.host | string | `nil` | External Statsd host to use. |
| externalStatsd.port | string | `nil` | External Statsd port to use. |
| prometheus-kafka-exporter.enabled | bool | `false` | Whether to install the `prometheus-kafka-exporter` or not. |
| prometheus-kafka-exporter.annotations | object | `{"prometheus.io/path":"/metrics","prometheus.io/port":"9308","prometheus.io/scrape":"true"}` | Map of annotations to add to the pods. |
| prometheus-kafka-exporter.kafkaServer | list | `["posthog-posthog-kafka:9092"]` | Specify the target Kafka brokers to monitor. |
| prometheus-postgres-exporter.enabled | bool | `false` | Whether to install the `prometheus-postgres-exporter` or not. |
| prometheus-postgres-exporter.annotations | object | `{"prometheus.io/path":"/metrics","prometheus.io/port":"9187","prometheus.io/scrape":"true"}` | Map of annotations to add to the pods. |
| prometheus-postgres-exporter.config | object | `{"datasource":{"host":"posthog-posthog-postgresql","passwordSecret":{"key":"postgresql-password","name":"posthog-posthog-postgresql"},"user":"postgres"}}` | Configuration options. |
| prometheus-redis-exporter.enabled | bool | `false` | Whether to install the `prometheus-redis-exporter` or not. |
| prometheus-redis-exporter.annotations | object | `{"prometheus.io/path":"/metrics","prometheus.io/port":"9121","prometheus.io/scrape":"true"}` | Map of annotations to add to the pods. |
| prometheus-redis-exporter.redisAddress | string | `"redis://posthog-posthog-redis-master:6379"` | Specify the target Redis instance to monitor. |
| installCustomStorageClass | bool | `false` |  |
| busybox.image | string | `"busybox:1.34"` | Specify the image to use for e.g. init containers |
| busybox.pullPolicy | string | `"IfNotPresent"` | Image pull policy |
| busybox.pullSecrets | list | `[]` |  |
| clusterDomain | string | `"cluster.local"` | Kubernetes cluster domain name |
| includeDefaultTopologySpreadConstraints | bool | `false` |  |

Dependent charts can also have values overwritten. For more info see our [docs](https://posthog.com/docs/self-host/deploy/configuration).

