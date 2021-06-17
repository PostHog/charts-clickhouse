# PostHog Helm Chart

> :warning: **This chart is not ready yet**: Be careful!

🦔 [PostHog](https://posthog.com/) is developer-friendly, open-source product analytics.

## Introduction

This chart bootstraps a [PostHog](https://posthog.com/) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

This installation is geared towards larger scalability (> 1M events per month).

It also optionally packages [Clickhouse](https://clickhouse.tech/), [PostgreSQL](https://github.com/kubernetes/charts/tree/master/stable/postgresql), [Redis](https://github.com/kubernetes/charts/tree/master/stable/redis) and [Apache Kafka](https://kafka.apache.org/) which are required for PostHog.

## TL;DR;

```console
helm repo add posthog https://posthog.github.io/charts-clickhouse/
helm repo update
helm install --timeout 20m posthog posthog/posthog
```

## Prerequisites

- Google Cloud kubernetes cluster
- Kubernetes 1.4+ with Beta APIs enabled
- helm >= v3
- PV provisioner support in the underlying infrastructure (with persistence storage enabled)

## Installing the Chart

To install the chart with the release name `posthog`:

```console
helm repo add posthog https://posthog.github.io/charts-clickhouse/
helm repo update
helm install --timeout 20m posthog posthog/posthog
```

The command deploys PostHog on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `posthog` deployment:

```console
$ helm delete posthog
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

> **Warning**: Jobs are not deleted automatically. They need to be manually deleted

```console
$ kubectl delete job/posthog-migrate
```

## Configuration

The following table lists the configurable parameters of the PostHog chart and their default values.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| image.repository | string | `"posthog/posthog"` | Posthog image repository |
| image.sha | string | `nil` | Posthog image sha |
| image.tag | string | `nil` | Posthog image tag, e.g. release-1.25.0 |
| image.default | string | `":release-1.26.0"` | Default image or tag |
| image.pullPolicy | string | `"IfNotPresent"` | Image pull policy |
| cloud | string | `"gcp"` | Cloud service being deployed on. Either `gcp` or `aws` |
| sentryDSN | string | `nil` | Sentry endpoint to send errors to |
| clickhouseOperator.enabled | bool | `false` | Whether to install clickhouse. If false, `clickhouse.host` must be set |
| clickhouseOperator.namespace | string | `nil` | Which namespace to install clickhouse operator to |
| clickhouseOperator.storage | string | `"2000Gi"` | How much storage space to preallocate for clickhouse |
| env | list | `[{"name":"ASYNC_EVENT_PROPERTY_USAGE","value":"true"},{"name":"EVENT_PROPERTY_USAGE_INTERVAL_SECONDS","value":"86400"}]` | Env vars to throw into every deployment (web, beat, worker, and plugin server) |
| pgbouncer | object | `{"replicacount":2}` | PgBouncer setup |
| pgbouncer.replicacount | int | `2` | How many replicas of pgbouncer to run |
| web.hpa | object | `{"cputhreshold":60,"enabled":false,"maxpods":10,"minpods":1}` | Web horizontal pod autoscaler settings |
| web.hpa.enabled | bool | `false` | Boolean to create a HorizontalPodAutoscaler for web |
| web.hpa.cputhreshold | int | `60` | CPU threshold percent for the web |
| web.hpa.minpods | int | `1` | Min pods for the web |
| web.hpa.maxpods | int | `10` | Max pods for the web |
| web.replicacount | int | `1` | Amount of web pods to run |
| web.resources | object | `{}` | Resource limits for web service. See https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#resource-requests-and-limits-of-pod-and-container for more |
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
| beat.nodeSelector | object | `{}` |  |
| beat.tolerations | list | `[]` |  |
| beat.affinity | object | `{}` |  |
| worker.hpa.enabled | bool | `false` | Boolean to create a HorizontalPodAutoscaler for worker |
| worker.hpa.cputhreshold | int | `60` |  |
| worker.hpa.minpods | int | `3` |  |
| worker.hpa.maxpods | int | `20` |  |
| worker.env | list | `[]` |  |
| worker.replicacount | int | `2` | How many replicas of workers to run |
| worker.resources | object | `{}` | Resource limits for workers |
| worker.nodeSelector | object | `{}` |  |
| worker.tolerations | list | `[]` |  |
| worker.affinity | object | `{}` |  |
| plugins.ingestion.enabled | bool | `true` | Whether to enable plugin-server based ingestion |
| plugins.hpa.enabled | bool | `false` | Boolean to create a HorizontalPodAutoscaler for plugin server |
| plugins.hpa.cputhreshold | int | `60` |  |
| plugins.hpa.minpods | int | `1` |  |
| plugins.hpa.maxpods | int | `10` |  |
| plugins.env | list | `[]` |  |
| plugins.replicacount | int | `2` | How many replicas of plugin-server to run |
| plugins.resources | object | `{}` |  |
| plugins.nodeSelector | object | `{}` |  |
| plugins.tolerations | list | `[]` |  |
| plugins.affinity | object | `{}` |  |
| email.from_email | string | `"hey@posthog.com"` | Outbound email sender |
| email.host | string | `"smtp.eu.mailgun.org"` | STMP host |
| email.port | int | `587` | STMP port |
| email.user | string | `"postmaster@mg.posthog.com"` | STMP login user |
| email.password | string | `nil` | STMP password |
| email.use_tls | bool | `true` | SMTP TLS for security |
| email.use_tls | string | `nil` | SMTP SSL for security |
| email.existingSecret | string | `nil` | SMTP password from an existing secret. When defined the `password` field is ignored |
| email.existingSecretKey | string | `nil` | Key to get from the `email.existingSecret` secret |
| service | object | `{"annotations":{},"externalPort":8000,"internalPort":8000,"name":"posthog","type":"NodePort"}` | Name of the service and what port to expose on the pod. Don't change these unless you know what you're doing |
| certManager.enabled | bool | `false` |  |
| ingress.enabled | bool | `true` | Enable ingress controller resource |
| ingress.type | string | `"clb"` | Ingress handler type. Either `clb` on gcp or `nginx` elsewhere |
| ingress.hostname | string | `"testk8s.posthog.net"` | URL to address your PostHog installation. You will need to set up DNS after installation |
| ingress.path | string | `"/*"` |  |
| ingress.gcp.ip_name | string | `"posthog-ip"` | Specifies the name of the global IP address resource to be associated with the google clb |
| ingress.gcp.forceHttps | bool | `true` | If true, will force a https redirect when accessed over http |
| ingress.letsencrypt | bool | `false` | Whether to enable letsencrypt. Set to true for type nginx |
| ingress.nginx.enabled | bool | `false` | Whether nginx is enabled |
| postgresql.enabled | bool | `true` | Install postgres server on kubernetes (see below) |
| postgresql.nameOverride | string | `"posthog-postgresql"` | Name override for postgresql app |
| postgresql.postgresqlDatabase | string | `"posthog"` | Postgresql database name |
| postgresql.postgresqlUsername | string | `"postgres"` | Postgresql database username |
| postgresql.postgresqlPassword | string | `"postgres"` | Postgresql database password |
| postgresql.persistence.enabled | bool | `true` | Enable persistence using PVC |
| postgresql.persistence.size | string | `"100Gi"` | PVC Storage Request for PostgreSQL volume |
| postgresql.postgresqlHost | string | `nil` | Host postgres is accessible from. Only set when internal PG is disabled |
| postgresql.postgresqlPort | string | `nil` | Host postgres is accessible from. Only set when internal PG is disabled |
| redis.enabled | bool | `true` | Install redis server on kubernetes (see below) |
| redis.nameOverride | string | `"posthog-redis"` | Name override for redis app |
| redis.host | string | `nil` | Host redis is accessible from. Only set when internal redis is disabled |
| redis.password | string | `nil` | Password for redis. Only set when internal redis is disabled |
| redis.port | string | `nil` | Port redis is accessible from. Only set when internal redis is disabled |
| redis.master.persistence.enabled | bool | `true` | Enable persistence using PVC |
| redis.master.persistence.size | string | `"8Gi"` | PVC Storage Request for Redis volume |
| kafka.enabled | bool | `true` | Install kafka on kubernetes |
| kafka.nameOverride | string | `"posthog-kafka"` | Name override for kafka app |
| kafka.url | string | `nil` | URL for kafka. Only set when internal kafka is disabled |
| kafka.host | string | `nil` | Host for kafka. Only set when internal kafka is disabled |
| kafka.port | string | `nil` | Port for kafka. Only set when internal kafka is disabled |
| kafka.service.enabled | bool | `false` |  |
| kafka.service.type | string | `"LoadBalancer"` |  |
| kafka.persistence.enabled | bool | `true` | Enable persistence using PVC |
| kafka.persistence.size | string | `"80Gi"` | PVC Storage Request for kafka volume |
| kafka.logRetentionBytes | string | `"_68_000_000_000"` | A size-based retention policy for logs -- Should be less than kafka.persistence.size, ideally 70-80% |
| kafka.logRetentionHours | int | `72` | The minimum age of a log file to be eligible for deletion due to age |
| clickhouse.enabled | bool | `true` | Use clickhouse as primary database |
| clickhouse.database | string | `"posthog"` | Clickhouse database |
| clickhouse.user | string | `"admin"` | Clickhouse user |
| clickhouse.password | string | `"a1f31e03-c88e-4ca6-a2df-ad49183d15d9"` | Clickhouse password |
| clickhouse.host | string | `nil` | Set if not installing clickhouse operator |
| clickhouse.replication | bool | `false` |  |
| clickhouse.secure | bool | `false` |  |
| clickhouse.verify | bool | `false` |  |
| clickhouse.async | bool | `false` |  |
| metrics.enabled | bool | `false` | Start an exporter for posthog metrics |
| metrics.livenessProbe.enabled | bool | `true` |  |
| metrics.livenessProbe.initialDelaySeconds | int | `30` |  |
| metrics.livenessProbe.periodSeconds | int | `5` |  |
| metrics.livenessProbe.timeoutSeconds | int | `2` |  |
| metrics.livenessProbe.failureThreshold | int | `3` |  |
| metrics.livenessProbe.successThreshold | int | `1` |  |
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
| metrics.serviceMonitor.selector.prometheus | string | `"kube-prometheus"` |  |
| cloudwatch.enabled | bool | `false` | Enable cloudwatch container insights to get logs and metrics on AWS |
| cloudwatch.region | string | `nil` | AWS region |
| cloudwatch.clusterName | string | `nil` | AWS EKS cluster name |
| cloudwatch.fluentBit | object | `{"port":2020,"readHead":"On","readTail":"Off","server":"On"}` | fluentBit configuration |
| hooks.affinity | object | `{}` | Affinity settings for hooks |
| hooks.migrate.env | list | `[]` | Env variables for migate hooks |
| hooks.migrate.resources | object | `{"limits":{"memory":"1000Mi"},"requests":{"memory":"1000Mi"}}` | Hook job resource limits/requests |
| serviceAccount.create | bool | `true` | Configures if a ServiceAccount with this name should be created |
| serviceAccount.name | string | `nil` |  |
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

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --timeout 20m \
  --set persistence.enabled=false,email.host=email \
  posthog .
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --timeout 20m -f my-values.yaml posthog .
```

## PostgreSQL

By default, PostgreSQL is installed as part of the chart. To use an external PostgreSQL server set `postgresql.enabled` to `false` and then set `postgresql.postgresHost` and `postgresql.postgresqlPassword`. The other options (`postgresql.postgresqlDatabase`, `postgresql.postgresqlUsername` and `postgresql.postgresqlPort`) may also want changing from their default values.

To avoid issues when upgrading this chart, provide `postgresql.postgresqlPassword` for subsequent upgrades. This is due to an issue in the PostgreSQL chart where password will be overwritten with randomly generated passwords otherwise. See https://github.com/helm/charts/tree/master/stable/postgresql#upgrade for more detail.

## Redis

By default, Redis is installed as part of the chart. To use an external Redis server/cluster set `redis.enabled` to `false` and then set `redis.host`. If your redis cluster uses password define it with `redis.password`, otherwise just omit it. Check the table above for more configuration options.

To avoid issues when upgrading this chart, provide `redis.password` for subsequent upgrades. Otherwise the redis pods will get recreated on every update, potentially incurring some downtime.

## Ingress

This chart provides support for Ingress resource. If you have an available Ingress Controller such as Nginx or Traefik you maybe want to set `ingress.enabled` to true and choose an `ingress.hostname` for the URL. Then, you should be able to access the installation using that address.

## Prometheus

This chart supports alerting. Set `prometheus.enabled` to true and set `prometheus.alertmanagerFiles` to the right configuration.

Read more at https://github.com/prometheus-community/helm-charts/tree/main/charts/prometheus and https://prometheus.io/docs/alerting/latest/configuration/

### Example configuration (pagerduty)

```yaml
prometheus:
  enabled: true

  alertmanagerFiles:
    alertmanager.yml:
      receivers:
        - name: default-receiver
          pagerduty_configs:
            - routing_key: YOUR_ROUTING_KEY
              description: "{{ range .Alerts }}{{ .Annotations.summary }}\n{{ end }}"

      route:
        group_by: [alertname]
        receiver: default-receiver
```

### Getting access to prometheus frontend

This might be useful when checking out metrics. Figure out your prometheus-server pod name via `kubectl get pods --namespace NS` and run:
`kubectl --namespace NS port-forward posthog-prometheus-server-XXX 9090`

After this you should be able to access prometheus server on localhost.
