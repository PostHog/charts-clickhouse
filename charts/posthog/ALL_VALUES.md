# PostHog Helm chart configuration

## Configuration

The following table lists the configurable parameters of the PostHog chart and their default values.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| image | object | `{"default":"@sha256:20af35fca6756d689d6705911a49dd6f2f6631e001ad43377b605cfc7c133eb4","pullPolicy":"IfNotPresent","repository":"posthog/posthog","sha":null,"tag":null}` |  This is a YAML-formatted file. Declare variables to be passed into your templates. |
| image.repository | string | `"posthog/posthog"` | Posthog image repository |
| image.sha | string | `nil` | Posthog image sha, e.g. sha256:20af35fca6756d689d6705911a49dd6f2f6631e001ad43377b605cfc7c133eb4 |
| image.tag | string | `nil` | Posthog image tag, e.g. release-1.25.0 |
| image.default | string | `"@sha256:20af35fca6756d689d6705911a49dd6f2f6631e001ad43377b605cfc7c133eb4"` | Default image or tag |
| image.pullPolicy | string | `"IfNotPresent"` | Image pull policy |
| cloud | string | `nil` | Required: Cloud service being deployed on. Either `gcp` or `aws` or `do` for DigitalOcean |
| sentryDSN | string | `nil` | Sentry endpoint to send errors to |
| clickhouseOperator.enabled | bool | `true` | Whether to install clickhouse. If false, `clickhouse.host` must be set |
| clickhouseOperator.namespace | string | `nil` | Which namespace to install clickhouse operator to (defaults to namespace chart is installed to) |
| clickhouseOperator.storage | string | `"20Gi"` | How much storage space to preallocate for clickhouse |
| clickhouseOperator.useNodeSelector | bool | `false` | If enabled, operator will prefer k8s nodes with tag `clickhouse:true` |
| clickhouseOperator.serviceType | string | `"NodePort"` | Service Type: LoadBalancer (allows external access) or NodePort (more secure, no extra cost) |
| env | list | `[{"name":"ASYNC_EVENT_PROPERTY_USAGE","value":"true"},{"name":"EVENT_PROPERTY_USAGE_INTERVAL_SECONDS","value":"86400"}]` | Env vars to throw into every deployment (web, beat, worker, and plugin server) |
| pgbouncer | object | `{"env":[],"extraVolumeMounts":[],"extraVolumes":[],"hpa":{"cputhreshold":60,"enabled":false,"maxpods":10,"minpods":1},"replicacount":1}` | PgBouncer setup |
| pgbouncer.hpa.enabled | bool | `false` | Boolean to create a HorizontalPodAutoscaler for pgbouncer -- This experimental and set up based on cpu utilization -- Adding pgbouncers can cause running out of connections for Postgres |
| pgbouncer.hpa.cputhreshold | int | `60` | CPU threshold percent for pgbouncer |
| pgbouncer.hpa.minpods | int | `1` | Min pods for pgbouncer |
| pgbouncer.hpa.maxpods | int | `10` | Max pods for pgbouncer |
| pgbouncer.replicacount | int | `1` | How many replicas of pgbouncer to run. Ignored if hpa is used |
| pgbouncer.env | list | `[]` | Additional env vars to be added to the pgbouncer deployment |
| pgbouncer.extraVolumeMounts | list | `[]` | Additional volumeMounts to be added to the pgbouncer deployment |
| pgbouncer.extraVolumes | list | `[]` | Additional volumes to be added to the pgbouncer deployment |
| web.hpa | object | `{"cputhreshold":60,"enabled":false,"maxpods":10,"minpods":1}` | Web horizontal pod autoscaler settings |
| web.hpa.enabled | bool | `false` | Boolean to create a HorizontalPodAutoscaler for web -- This experimental |
| web.hpa.cputhreshold | int | `60` | CPU threshold percent for the web |
| web.hpa.minpods | int | `1` | Min pods for the web |
| web.hpa.maxpods | int | `10` | Max pods for the web |
| web.replicacount | int | `1` | Amount of web pods to run. Ignored if hpa is used |
| web.resources | object | `{}` | Resource limits for web service. See https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#resource-requests-and-limits-of-pod-and-container for more |
| web.env | list | `[{"name":"SOCIAL_AUTH_GOOGLE_OAUTH2_KEY","value":null},{"name":"SOCIAL_AUTH_GOOGLE_OAUTH2_SECRET","value":null},{"name":"SOCIAL_AUTH_GOOGLE_OAUTH2_WHITELISTED_DOMAINS","value":"posthog.com"}]` | Env variables for web container |
| web.env[0] | object | `{"name":"SOCIAL_AUTH_GOOGLE_OAUTH2_KEY","value":null}` | Set google oauth 2 key. Requires posthog ee license. |
| web.env[1] | object | `{"name":"SOCIAL_AUTH_GOOGLE_OAUTH2_SECRET","value":null}` | Set google oauth 2 secret. Requires posthog ee license. |
| web.env[2] | object | `{"name":"SOCIAL_AUTH_GOOGLE_OAUTH2_WHITELISTED_DOMAINS","value":"posthog.com"}` | Set google oauth 2 whitelisted domains users can log in from |
| web.internalMetrics.capture | bool | `true` | Whether to capture information on operation of posthog into posthog, exposed in /instance/status page |
| web.nodeSelector | object | `{}` | Node labels for web pod assignment |
| web.tolerations | list | `[]` | Toleration labels for web pod assignment |
| web.affinity | object | `{}` | Affinity settings for web pod assignment |
| web.secureCookies | bool | `true` |  |
| web.livenessProbe.failureThreshold | int | `5` | The liveness probe failure threshold |
| web.livenessProbe.initialDelaySeconds | int | `50` | The liveness probe initial delay seconds |
| web.livenessProbe.periodSeconds | int | `10` | The liveness probe period seconds |
| web.livenessProbe.successThreshold | int | `1` | The liveness probe success threshold |
| web.livenessProbe.timeoutSeconds | int | `2` | The liveness probe timeout seconds |
| web.readinessProbe.failureThreshold | int | `10` | The readiness probe failure threshold |
| web.readinessProbe.initialDelaySeconds | int | `50` | The readiness probe initial delay seconds |
| web.readinessProbe.periodSeconds | int | `10` | The readiness probe period seconds |
| web.readinessProbe.successThreshold | int | `1` | The readiness probe success threshold |
| web.readinessProbe.timeoutSeconds | int | `2` | The readiness probe timeout seconds |
| beat.replicacount | int | `1` | How many posthog 'beat' instances to run |
| beat.resources | object | `{}` | Resource limits for 'beat' instances |
| beat.nodeSelector | object | `{}` |    cpu: 200m   memory: 200Mi requests:   cpu: 100m   memory: 100Mi |
| beat.tolerations | list | `[]` |  |
| beat.affinity | object | `{}` |  |
| worker.hpa.enabled | bool | `false` | Boolean to create a HorizontalPodAutoscaler for worker -- This experimental |
| worker.hpa.cputhreshold | int | `60` |  |
| worker.hpa.minpods | int | `1` |  |
| worker.hpa.maxpods | int | `20` |  |
| worker.env | list | `[]` |  |
| worker.replicacount | int | `1` | How many replicas of workers to run. Ignored if hpa is used |
| worker.resources | object | `{}` | Resource limits for workers |
| worker.nodeSelector | object | `{}` |    cpu: 300m   memory: 500Mi requests:   cpu: 100m   memory: 100Mi |
| worker.tolerations | list | `[]` |  |
| worker.affinity | object | `{}` |  |
| plugins.ingestion.enabled | bool | `true` | Whether to enable plugin-server based ingestion |
| plugins.hpa.enabled | bool | `false` | Boolean to create a HorizontalPodAutoscaler for plugin server -- This experimental, based on cpu util which is not necessarilly the bottleneck |
| plugins.hpa.cputhreshold | int | `60` |  |
| plugins.hpa.minpods | int | `1` |  |
| plugins.hpa.maxpods | int | `10` |  |
| plugins.env | list | `[]` |  |
| plugins.replicacount | int | `1` | How many replicas of plugin-server to run. Ignored if hpa is used |
| plugins.resources | object | `{}` |  |
| plugins.nodeSelector | object | `{}` |    cpu: 300m   memory: 500Mi requests:   cpu: 100m   memory: 100Mi |
| plugins.tolerations | list | `[]` |  |
| plugins.affinity | object | `{}` |  |
| email.from_email | string | `nil` | Outbound email sender |
| email.host | string | `nil` | STMP host |
| email.port | string | `nil` | STMP port |
| email.user | string | `nil` | STMP login user |
| email.password | string | `nil` | STMP password |
| email.use_tls | bool | `true` | SMTP TLS for security |
| email.use_ssl | string | `nil` | SMTP SSL for security |
| email.existingSecret | string | `nil` | SMTP password from an existing secret. When defined the `password` field is ignored |
| email.existingSecretKey | string | `nil` | Key to get from the `email.existingSecret` secret |
| service | object | `{"annotations":{},"externalPort":8000,"internalPort":8000,"name":"posthog","type":"NodePort"}` | Name of the service and what port to expose on the pod. Don't change these unless you know what you're doing |
| certManager.enabled | bool | `false` | Whether to install cert-manager. Validates certs for nginx ingress |
| ingress.enabled | bool | `true` | Enable ingress controller resource |
| ingress.type | string | `nil` | Ingress handler type. Defaults to `nginx` if nginx is enabled and to `clb` on gcp. |
| ingress.hostname | string | `nil` | URL to address your PostHog installation. You will need to set up DNS after installation |
| ingress.gcp.ip_name | string | `"posthog"` | Specifies the name of the global IP address resource to be associated with the google clb |
| ingress.gcp.forceHttps | bool | `true` | If true, will force a https redirect when accessed over http |
| ingress.gcp.secretName | string | `""` | Specifies the name of the tls secret to be used by the ingress. If not specified a managed certificate will be generated. |
| ingress.letsencrypt | string | `nil` | Whether to enable letsencrypt. Defaults to true if hostname is defined and nginx and certManager are enabled otherwise false. |
| ingress.nginx.enabled | bool | `false` | Whether nginx is enabled |
| ingress.nginx.redirectToTLS | bool | `true` | Whether to redirect to TLS with nginx ingress. |
| ingress.annotations | object | `{}` | Extra annotations |
| ingress.secretName | string | `nil` | TLS secret to be used by the ingress. |
| postgresql.enabled | bool | `true` | Install postgres server on kubernetes (see below) |
| postgresql.nameOverride | string | `"posthog-postgresql"` | Name override for postgresql app |
| postgresql.postgresqlDatabase | string | `"posthog"` | Postgresql database name |
| postgresql.postgresqlUsername | string | `"postgres"` | Postgresql database username |
| postgresql.postgresqlPassword | string | `"postgres"` | Postgresql database password |
| postgresql.persistence.enabled | bool | `true` | Enable persistence using PVC |
| postgresql.persistence.size | string | `"10Gi"` | PVC Storage Request for PostgreSQL volume |
| postgresql.postgresqlHost | string | `nil` | Host postgres is accessible from. Only set when internal PG is disabled |
| postgresql.postgresqlPort | string | `nil` | Host postgres is accessible from. Only set when internal PG is disabled |
| redis.enabled | bool | `true` | Install redis server on kubernetes (see below) |
| redis.nameOverride | string | `"posthog-redis"` | Name override for redis app |
| redis.architecture | string | `"standalone"` | Either standalone or cluster. |
| redis.auth.enabled | bool | `false` | Don't require password by default |
| redis.host | string | `nil` | Host redis is accessible from. Only set when internal redis is disabled |
| redis.password | string | `nil` | Password for redis. Only set when internal redis is disabled |
| redis.port | string | `nil` | Port redis is accessible from. Only set when internal redis is disabled |
| redis.master.persistence.enabled | bool | `true` | Enable persistence using PVC |
| redis.master.persistence.size | string | `"5Gi"` | PVC Storage Request for Redis volume |
| kafka.enabled | bool | `true` | Install kafka on kubernetes |
| kafka.nameOverride | string | `"posthog-kafka"` | Name override for kafka app |
| kafka.url | string | `nil` | URL for kafka. Only set when internal kafka is disabled |
| kafka.host | string | `nil` | Host for kafka. Only set when internal kafka is disabled |
| kafka.port | string | `nil` | Port for kafka. Only set when internal kafka is disabled |
| kafka.service.enabled | bool | `false` |  |
| kafka.service.type | string | `"NodePort"` |  |
| kafka.persistence.enabled | bool | `true` | Enable persistence using PVC |
| kafka.persistence.size | string | `"5Gi"` | PVC Storage Request for kafka volume |
| kafka.logRetentionBytes | string | `"_4_000_000_000"` | A size-based retention policy for logs -- Should be less than kafka.persistence.size, ideally 70-80% |
| kafka.logRetentionHours | int | `24` | The minimum age of a log file to be eligible for deletion due to age |
| kafka.zookeeper.enabled | bool | `false` | Install zookeeper on kubernetes |
| kafka.externalZookeeper.servers | list | `["posthog-posthog-zookeeper:2181"]` | URL for zookeeper. Only set when internal zookeeper is disabled -- IF using default clickhouse zookeeper use <deployment-name>-posthog-zookeeper |
| zookeeper.enabled | bool | `true` | Install zookeeper on kubernetes |
| zookeeper.nameOverride | string | `"posthog-zookeeper"` | Name override for zookeeper app |
| zookeeper.replicaCount | int | `3` | replica count for zookeeper |
| clickhouse.enabled | bool | `true` | Use clickhouse as primary database |
| clickhouse.database | string | `"posthog"` | Clickhouse database |
| clickhouse.user | string | `"admin"` | Clickhouse user |
| clickhouse.password | string | `"a1f31e03-c88e-4ca6-a2df-ad49183d15d9"` | Clickhouse password |
| clickhouse.host | string | `nil` | Set if not installing clickhouse operator |
| clickhouse.replication | bool | `false` |  |
| clickhouse.secure | bool | `false` |  |
| clickhouse.verify | bool | `false` |  |
| clickhouse.async | bool | `false` |  |
| clickhouse.customStorageClass | string | `""` | Custom Storage Class in k8s |
| metrics.enabled | bool | `false` | Start an exporter for posthog metrics |
| metrics.livenessProbe | object | `{"enabled":true,"failureThreshold":3,"initialDelaySeconds":30,"periodSeconds":5,"successThreshold":1,"timeoutSeconds":2}` | Metrics pods livenessProbe settings |
| metrics.readinessProbe | object | `{"enabled":true,"failureThreshold":3,"initialDelaySeconds":30,"periodSeconds":5,"successThreshold":1,"timeoutSeconds":2}` | Metrics pods readinessProbe settings |
| metrics.resources | object | `{}` | Metrics resource requests/limits. See more at http://kubernetes.io/docs/user-guide/compute-resources/ |
| metrics.nodeSelector | object | `{}` | Node labels for metrics pod |
| metrics.tolerations | list | `[]` | Toleration labels for metrics pod assignment |
| metrics.affinity | object | `{}` | Affinity settings for metrics pod |
| metrics.service | object | `{"labels":{},"type":"ClusterIP"}` |  Optional extra labels for pod, i.e. redis-client: "true" podLabels: [] |
| metrics.service.type | string | `"ClusterIP"` | Kubernetes service type for metrics service |
| metrics.service.labels | object | `{}` | Additional labels for metrics service |
| metrics.image.repository | string | `"prom/statsd-exporter"` | Metrics exporter image repository |
| metrics.image.tag | string | `"v0.10.5"` | Metrics exporter image tag |
| metrics.image.pullPolicy | string | `"IfNotPresent"` | Metrics exporter image pull policy |
| metrics.serviceMonitor.enabled | bool | `false` | if `true`, creates a Prometheus Operator ServiceMonitor (also requires `metrics.enabled` to be `true`) |
| metrics.serviceMonitor.namespace | string | `nil` | Optional namespace which Prometheus is running in |
| metrics.serviceMonitor.interval | string | `nil` | How frequently to scrape metrics (use by default, falling back to Prometheus' default) |
| metrics.serviceMonitor.selector | object | `{"prometheus":"kube-prometheus"}` | Default to kube-prometheus install (CoreOS recommended), but should be set according to Prometheus install |
| cloudwatch.enabled | bool | `false` | Enable cloudwatch container insights to get logs and metrics on AWS |
| cloudwatch.region | string | `nil` | AWS region |
| cloudwatch.clusterName | string | `nil` | AWS EKS cluster name |
| cloudwatch.fluentBit | object | `{"port":2020,"readHead":"On","readTail":"Off","server":"On"}` | fluentBit configuration |
| hooks.affinity | object | `{}` | Affinity settings for hooks |
| hooks.migrate.env | list | `[]` | Env variables for migate hooks |
| hooks.migrate.resources | object | `{}` | Hook job resource limits/requests |
| serviceAccount.create | bool | `true` | Configures if a ServiceAccount with this name should be created |
| serviceAccount.name | string | `nil` | name of the ServiceAccount to be used by access-controlled resources. @default autogenerated |
| serviceAccount.annotations | object | `{}` | Configures annotation for the ServiceAccount |
| prometheus.enabled | bool | `false` | Whether to enable a minimal prometheus installation for getting alerts/monitoring the stack |
| prometheus.alertmanager.enabled | bool | `true` | If false, alertmanager will not be installed |
| prometheus.alertmanager.resources | object | `{"limits":{"cpu":"100m"},"requests":{"cpu":"50m"}}` | alertmanager resource requests and limits |
| prometheus.kubeStateMetrics.enabled | bool | `true` | If false, kube-state-metrics sub-chart will not be installed |
| prometheus.nodeExporter.enabled | bool | `true` | If false, node-exporter will not be installed |
| prometheus.nodeExporter.resources | object | `{"limits":{"cpu":"100m","memory":"50Mi"},"requests":{"cpu":"50m","memory":"30Mi"}}` | node-exporter resource limits & requests |
| prometheus.pushgateway.enabled | bool | `false` | If false, pushgateway will not be installed |
| prometheus.alertmanagerFiles."alertmanager.yml" | object | `{"global":{},"receivers":[{"name":"default-receiver"}],"route":{"group_by":["alertname"],"receiver":"default-receiver"}}` | alertmanager configuration rules. See https://prometheus.io/docs/alerting/latest/configuration/ |
| prometheus.serverFiles."alerting_rules.yml" | object | `{"groups":[{"name":"Posthog alerts","rules":[{"alert":"PodDown","annotations":{"description":"Pod {{ $labels.kubernetes_pod_name }} in namespace {{ $labels.kubernetes_namespace }} down for more than 5 minutes.","summary":"Pod {{ $labels.kubernetes_pod_name }} down."},"expr":"up{job=\"kubernetes-pods\"} == 0","for":"1m","labels":{"severity":"alert"}},{"alert":"PodFrequentlyRestarting","annotations":{"description":"Pod {{$labels.namespace}}/{{$labels.pod}} was restarted {{$value}} times within the last hour","summary":"Pod is restarting frequently"},"expr":"increase(kube_pod_container_status_restarts_total[1h]) > 5","for":"10m","labels":{"severity":"warning"}},{"alert":"VolumeRemainingCapacityLowTest","annotations":{"description":"Persistent volume claim {{ $labels.persistentvolumeclaim }} disk usage is above 85% for past 5 minutes","summary":"Kubernetes {{ $labels.persistentvolumeclaim }} is full (host {{ $labels.kubernetes_io_hostname }})"},"expr":"kubelet_volume_stats_used_bytes/kubelet_volume_stats_capacity_bytes >= 0.85","for":"5m","labels":{"severity":"page"}}]}]}` | Alerts configuration, see https://prometheus.io/docs/prometheus/latest/configuration/alerting_rules/ |
| statsd | object | `{"enabled":false,"podAnnotations":{"prometheus.io/path":"/metrics","prometheus.io/port":"9102","prometheus.io/scrape":"true"}}` | Prometheus StatsD configuration, see https://github.com/prometheus-community/helm-charts/tree/main/charts/prometheus-statsd-exporter |

Dependent charts can also have values overwritten. Preface values with postgresql.*
