# PostHog Helm chart configuration

![Version: 13.1.0](https://img.shields.io/badge/Version-13.1.0-informational?style=flat-square) ![AppVersion: 1.32.0](https://img.shields.io/badge/AppVersion-1.32.0-informational?style=flat-square)

## Configuration

The following table lists the configurable parameters of the PostHog chart and their default values.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| image.repository | string | `"posthog/posthog"` | Posthog image repository |
| image.sha | string | `nil` | Posthog image sha, e.g. sha256:20af35fca6756d689d6705911a49dd6f2f6631e001ad43377b605cfc7c133eb4 |
| image.tag | string | `nil` | Posthog image tag, e.g. release-1.32.0 |
| image.default | string | `":release-1.32.0"` | Default image or tag, e.g. `:release-1.32.0` Do not overwrite, use image.sha or image.tag instead. |
| image.pullPolicy | string | `"IfNotPresent"` | Image pull policy |
| cloud | string | `nil` | Required: Cloud service being deployed on. Either `gcp` or `aws` or `do` for DigitalOcean |
| sentryDSN | string | `nil` | Sentry endpoint to send errors to |
| env | list | `[{"name":"ASYNC_EVENT_PROPERTY_USAGE","value":"true"},{"name":"EVENT_PROPERTY_USAGE_INTERVAL_SECONDS","value":"86400"}]` | Env vars to throw into every deployment (web, worker, and plugin server) |
| migrate.enabled | bool | `true` | Whether to install the PostHog migrate job or not |
| events.enabled | bool | `true` | Whether to install the PostHog events stack or not |
| events.hpa | object | `{"cputhreshold":60,"enabled":false,"maxpods":10,"minpods":1}` | events horizontal pod autoscaler settings |
| events.hpa.enabled | bool | `false` | This experimental |
| events.hpa.cputhreshold | int | `60` | CPU threshold percent for the events stack |
| events.hpa.minpods | int | `1` | Min pods for the events stack |
| events.hpa.maxpods | int | `10` | Max pods for the events stack |
| events.replicacount | int | `1` | Amount of events pods to run. Ignored if hpa is used |
| web.enabled | bool | `true` | Whether to install the PostHog web stack or not |
| web.hpa | object | `{"cputhreshold":60,"enabled":false,"maxpods":10,"minpods":1}` | Web horizontal pod autoscaler settings |
| web.hpa.enabled | bool | `false` | This experimental |
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
| worker.enabled | bool | `true` | Whether to install the PostHog worker stack or not |
| worker.hpa.enabled | bool | `false` | This experimental |
| worker.hpa.cputhreshold | int | `60` |  |
| worker.hpa.minpods | int | `1` |  |
| worker.hpa.maxpods | int | `20` |  |
| worker.env | list | `[]` |  |
| worker.replicacount | int | `1` | How many replicas of workers to run. Ignored if hpa is used |
| worker.resources | object | `{}` | Resource limits for workers |
| worker.nodeSelector | object | `{}` |  |
| worker.tolerations | list | `[]` |  |
| worker.affinity | object | `{}` |  |
| plugins.enabled | bool | `true` | Whether to install the PostHog plugin stack or not |
| plugins.ingestion.enabled | bool | `true` | Whether to enable plugin-server based ingestion |
| plugins.hpa.enabled | bool | `false` | This experimental, based on cpu util which is not necessarily the bottleneck |
| plugins.hpa.cputhreshold | int | `60` |  |
| plugins.hpa.minpods | int | `1` |  |
| plugins.hpa.maxpods | int | `10` |  |
| plugins.env | list | `[]` |  |
| plugins.replicacount | int | `1` | How many replicas of plugin-server to run. Ignored if hpa is used |
| plugins.resources | object | `{}` |  |
| plugins.nodeSelector | object | `{}` |  |
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
| saml.enforced | bool | `false` | Whether password-based login is disabled and users automatically redirected to SAML login. Requires SAML to be properly configured. |
| saml.disabled | bool | `false` | Whether SAML should be completely disabled. If set at build time, this will also prevent SAML dependencies from being installed. |
| saml.entity_id | string | `nil` | Entity ID from your SAML IdP. entity_id: "id-from-idp-5f9d4e-47ca-5080" |
| saml.acs_url | string | `nil` | Assertion Consumer Service URL from your SAML IdP. acs_url: "https://mysamlidp.com/saml2" |
| saml.x509_cert | string | `nil` | Public X509 certificate from your SAML IdP to validate SAML assertions x509_cert: | MIID3DCCAsSgAwIBAgIUdriHo8qmAU1I0gxsI7cFZHmna38wDQYJKoZIhvcNAQEF BQAwRTEQMA4GA1UECgwHUG9zdEhvZzEVMBMGA1UECwwMT25lTG9naW4gSWRQMRow GAYDVQQDDBFPbmVMb2dpbiBBY2NvdW50IDAeFw0yMTA4MTYyMTUyMzNaFw0yNjA4 MTYyMTUyMzNaMEUxEDAOBgNVBAoMB1Bvc3RIb2cxFTATBgNVBAsMDE9uZUxvZ2lu IElkUDEaMBgGA1UEAwwRT25lTG9naW4gQWNjb3VudCAwggEiMA0GCSqGSIb3DQEB AQUAA4IBDwAwggEKAoIBAQDEfUWFIU38ztF2EgijVsIbnlB8OIwkjZU8c34B9VwZ BQQUSxbrkuT9AX/5O27G04TBCHFZsXRId+ABSjVo8daCPu0d38Quo9KS3V3627Nw YcTYsje95lB02E/PgfiEQ6ZGCOV0P4xY9C99d26PoYTcoMT1S73jDDMOFtoD5WXG ZsKqwBks1jbLkv6RYoFBlZX00aGzOXDzUXI59/0c15KR4EzgTad0t6CU7X0HZ2Qf xGUiRb7hDLvgSby0SzpQpYUyYDnN9aSNYzpu1hiyIqrhQ7kZNy7LyGBz0UIuIImF pF6A3bzzrR4wdacFY9U0vmqFXXcepxuT5p2UyAxwbLeDAgMBAAGjgcMwgcAwDAYD VR0TAQH/BAIwADAdBgNVHQ4EFgQURLVVKanZPoXGEfYr1HmlaCEoD54wgYAGA1Ud IwR5MHeAFES1VSmp2T6FxhH2K9R5pWghKA+eoUmkRzBFMRAwDgYDVQQKDAdQb3N0 SG9nMRUwEwYDVQQLDAxPbmVMb2dpbiBJZFAxGjAYBgNVBAMMEU9uZUxvZ2luIEFj Y291bnQgghR2uIejyqYBTUjSDGwjtwVkeadrfzAOBgNVHQ8BAf8EBAMCB4AwDQYJ KoZIhvcNAQEFBQADggEBALP5lhlcV8avbnVnqO7PBtlS2mVOJ2B7obm50OaJCbRh t0I/dcNssWhT31/zmtNfKtrFicNImlKhdirApxpIp1WLEFY01a40GLmO6FG/WVvB EzwXonWP+cP8jYQnqZ15JkuHjP3DYJuOak2GqAJAfaGO67q6IkRZzRq6UwEUgNJD TlcsJAFaJDrcw07TY3mRFragdzGC7Xt/CM6r/0seY3+VBwMUMiJlvawcyQxap7om EdgmQkJA8Dk6f+geI+U7jV3orkPiofBJi9K6cp5Fd9usut8jwi3GYg2wExNGbhF4 wlMD1LOhymQGBnTXPk+000nkBnYdqEnqXzVpDiCG1Pc= |
| saml.attr_permanent_id | string | `nil` | Name of attribute that contains the permanent ID of the user in SAML assertions. attr_permanent_id: "nameID" |
| saml.attr_first_name | string | `nil` | Name of attribute that contains the first name of the user in SAML assertions. attr_first_name: "firstName" |
| saml.attr_last_name | string | `nil` | Name of attribute that contains the last name of the user in SAML assertions. attr_last_name: "lastName" |
| saml.attr_email | string | `nil` | Name of attribute that contains the email of the user in SAML assertions. attr_email: "email" |
| service | object | `{"annotations":{},"externalPort":8000,"internalPort":8000,"name":"posthog","type":"NodePort"}` | Name of the service and what port to expose on the pod. Don't change these unless you know what you're doing |
| cert-manager.enabled | bool | `false` | Whether to install cert-manager. Validates certs for nginx ingress |
| cert-manager.installCRDs | bool | `true` | Whether to install cert-manager CRDs. |
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
| postgresql.enabled | bool | `true` | Install postgres server on kubernetes (see below) |
| postgresql.nameOverride | string | `"posthog-postgresql"` | Name override for postgresql app |
| postgresql.postgresqlDatabase | string | `"posthog"` | Postgresql database name |
| postgresql.postgresqlUsername | string | `"postgres"` | Postgresql database username |
| postgresql.postgresqlPassword | string | `"postgres"` | Postgresql database password |
| postgresql.persistence.enabled | bool | `true` | Enable persistence using PVC |
| postgresql.persistence.size | string | `"10Gi"` | PVC Storage Request for PostgreSQL volume |
| postgresql.postgresqlHost | string | `nil` | Host postgres is accessible from. Only set when internal PG is disabled |
| postgresql.postgresqlPort | string | `nil` | Host postgres is accessible from. Only set when internal PG is disabled |
| pgbouncer | object | `{"enabled":true,"env":[],"extraVolumeMounts":[],"extraVolumes":[],"hpa":{"cputhreshold":60,"enabled":false,"maxpods":10,"minpods":1},"replicacount":1}` | PgBouncer setup |
| pgbouncer.enabled | bool | `true` | Whether to install PGBouncer or not |
| pgbouncer.hpa.enabled | bool | `false` | Adding pgbouncers can cause running out of connections for Postgres |
| pgbouncer.hpa.cputhreshold | int | `60` | CPU threshold percent for pgbouncer |
| pgbouncer.hpa.minpods | int | `1` | Min pods for pgbouncer |
| pgbouncer.hpa.maxpods | int | `10` | Max pods for pgbouncer |
| pgbouncer.replicacount | int | `1` | How many replicas of pgbouncer to run. Ignored if hpa is used |
| pgbouncer.env | list | `[]` | Additional env vars to be added to the pgbouncer deployment |
| pgbouncer.extraVolumeMounts | list | `[]` | Additional volumeMounts to be added to the pgbouncer deployment |
| pgbouncer.extraVolumes | list | `[]` | Additional volumes to be added to the pgbouncer deployment |
| redis.enabled | bool | `true` |  |
| redis.nameOverride | string | `"posthog-redis"` |  |
| redis.fullnameOverride | string | `""` |  |
| redis.architecture | string | `"standalone"` |  |
| redis.auth.enabled | bool | `false` |  |
| redis.auth.password | string | `""` |  |
| redis.auth.existingSecret | string | `""` |  |
| redis.auth.existingSecretPasswordKey | string | `""` |  |
| redis.master.persistence.enabled | bool | `true` |  |
| redis.master.persistence.size | string | `"5Gi"` |  |
| externalRedis.host | string | `""` |  |
| externalRedis.port | int | `6379` |  |
| externalRedis.password | string | `""` |  |
| externalRedis.existingSecret | string | `""` |  |
| externalRedis.existingSecretPasswordKey | string | `""` |  |
| kafka.enabled | bool | `true` | Install kafka on kubernetes |
| kafka.nameOverride | string | `"posthog-kafka"` | Name override for kafka app |
| kafka.url | string | `nil` | URL for kafka. Only set when internal kafka is disabled |
| kafka.host | string | `nil` | Host for kafka. Only set when internal kafka is disabled |
| kafka.port | string | `nil` | Port for kafka. Only set when internal kafka is disabled |
| kafka.service.enabled | bool | `false` |  |
| kafka.service.type | string | `"NodePort"` |  |
| kafka.persistence.enabled | bool | `true` | Enable persistence using PVC |
| kafka.persistence.size | string | `"20Gi"` | PVC Storage Request for kafka volume |
| kafka.logRetentionBytes | string | `"_15_000_000_000"` | Should be less than kafka.persistence.size, minimum 1GB |
| kafka.logRetentionHours | int | `24` | The minimum age of a log file to be eligible for deletion due to age |
| kafka.zookeeper.enabled | bool | `false` | Install zookeeper on kubernetes |
| kafka.externalZookeeper.servers | list | `["posthog-posthog-zookeeper:2181"]` | IF using default clickhouse zookeeper use <deployment-name>-posthog-zookeeper |
| zookeeper.enabled | bool | `true` | Install zookeeper on kubernetes |
| zookeeper.nameOverride | string | `"posthog-zookeeper"` | Name override for zookeeper app |
| zookeeper.replicaCount | int | `1` | replica count for zookeeper |
| clickhouse.enabled | bool | `true` | Whether to install clickhouse. If false, `clickhouse.host` must be set |
| clickhouse.namespace | string | `nil` | Which namespace to install clickhouse and the clickhouse-operator to (defaults to namespace chart is installed to) |
| clickhouse.cluster | string | `"posthog"` | Clickhouse cluster |
| clickhouse.database | string | `"posthog"` | Clickhouse database |
| clickhouse.user | string | `"admin"` | Clickhouse user |
| clickhouse.password | string | `"a1f31e03-c88e-4ca6-a2df-ad49183d15d9"` | Clickhouse password |
| clickhouse.secure | bool | `false` | Whether to use TLS connection connecting to ClickHouse |
| clickhouse.verify | bool | `false` | Whether to verify TLS certificate on connection to ClickHouse |
| clickhouse.tolerations | list | `[]` | Toleration labels for clickhouse pod assignment |
| clickhouse.affinity | object | `{}` | Affinity settings for clickhouse pod |
| clickhouse.resources | object | `{}` | Clickhouse resource requests/limits. See more at http://kubernetes.io/docs/user-guide/compute-resources/ |
| clickhouse.securityContext.enabled | bool | `true` |  |
| clickhouse.securityContext.runAsUser | int | `101` |  |
| clickhouse.securityContext.runAsGroup | int | `101` |  |
| clickhouse.securityContext.fsGroup | int | `101` |  |
| clickhouse.serviceType | string | `"NodePort"` | Service Type: LoadBalancer (allows external access) or NodePort (more secure, no extra cost) |
| clickhouse.useNodeSelector | bool | `false` | If enabled, operator will prefer k8s nodes with tag `clickhouse:true` |
| clickhouse.persistence.enabled | bool | `true` |  |
| clickhouse.persistence.existingClaim | string | `""` |  |
| clickhouse.persistence.storageClass | string | `nil` |  |
| clickhouse.persistence.size | string | `"20Gi"` |  |
| clickhouse.profiles | object | `{}` |  |
| clickhouse.defaultProfiles.default/allow_experimental_window_functions | string | `"1"` |  |
| externalClickhouse.host | string | `nil` | Host of the external cluster. This is required when clickhouse.enabled is false |
| externalClickhouse.cluster | string | `nil` | Name of the external cluster to run DDL queries on. This is required when clickhouse.enabled is false |
| externalClickhouse.database | string | `"posthog"` | Database name for the external cluster |
| externalClickhouse.user | string | `nil` | User name for the external cluster to connect to the external cluster as |
| externalClickhouse.password | string | `nil` | Password for the cluster. Ignored if existingClickhouse.existingSecret is set |
| externalClickhouse.existingSecret | string | `nil` | Name of an existing Kubernetes secret object containing the password |
| externalClickhouse.existingSecretPasswordKey | string | `nil` | Name of the key pointing to the password in your Kubernetes secret |
| externalClickhouse.secure | bool | `false` | Whether to use TLS connection connecting to ClickHouse |
| externalClickhouse.verify | bool | `false` | Whether to verify TLS connection connecting to ClickHouse |
| metrics.enabled | bool | `false` | Start an exporter for posthog metrics |
| metrics.livenessProbe | object | `{"enabled":true,"failureThreshold":3,"initialDelaySeconds":30,"periodSeconds":5,"successThreshold":1,"timeoutSeconds":2}` | Metrics pods livenessProbe settings |
| metrics.readinessProbe | object | `{"enabled":true,"failureThreshold":3,"initialDelaySeconds":30,"periodSeconds":5,"successThreshold":1,"timeoutSeconds":2}` | Metrics pods readinessProbe settings |
| metrics.resources | object | `{}` | Metrics resource requests/limits. See more at http://kubernetes.io/docs/user-guide/compute-resources/ |
| metrics.nodeSelector | object | `{}` | Node labels for metrics pod |
| metrics.tolerations | list | `[]` | Toleration labels for metrics pod assignment |
| metrics.affinity | object | `{}` | Affinity settings for metrics pod |
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
| installCustomStorageClass | bool | `false` |  |

Dependent charts can also have values overwritten. For more info see our [docs](https://posthog.com/docs/self-host/deploy/configuration).

