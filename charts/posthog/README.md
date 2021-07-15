# PostHog Helm Chart

[![Latest release of the Helm chart](https://img.shields.io/badge/dynamic/yaml.svg?label=Helm%20chart%20version&url=https://posthog.github.io/charts-clickhouse/index.yaml&query=$.entries.posthog[:1].version&logo=helm)](https://github.com/PostHog/charts-clickhouse)
[![Latest release app version](https://img.shields.io/badge/dynamic/yaml.svg?label=App%20version&url=https://posthog.github.io/charts-clickhouse/index.yaml&query=$.entries.posthog[:1].appVersion)](https://github.com/PostHog/posthog)
[![MIT License](https://img.shields.io/badge/License-MIT-red.svg?style=flat-square)](https://opensource.org/licenses/MIT)
[![Slack](https://img.shields.io/badge/PostHog_chat-slack-blue?logo=slack)](https://posthog.com/slack)


-----

🦔 [PostHog](https://posthog.com/) is developer-friendly, open-source product analytics.

This chart bootstraps a [PostHog](https://posthog.com/) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager. The chart uses the scalable [ClickHouse](https://clickhouse.tech/) database for powering analytics.

## Prerequisites

- [Kubernetes](https://kubernetes.io/) 1.6+ with Beta APIs enabled
- [Helm](https://helm.sh/) >= v3

## Click to see details for pre-install steps for your chosen deployment option

<details>
  <summary>
    <b>Google Cloud</b>
  </summary>
<br />

First we need to set up a Kubernetes Cluster, see [Google Cloud Kubernetes Engine (GKE)](https://cloud.google.com/kubernetes-engine/).

Here's the minimal required `values.yaml` that we'll be using later. You can find an overview of the parameters that can be configured during installation under [configuration](#configuration).
```yaml
cloud: "gcp"
ingress:
  hostname: <your-hostname>
  nginx:
    enabled: false
certManager:
  enabled: false
```

### Installing the chart

To install the chart with the release name `posthog` in `posthog` namespace, run the following:

```console
helm repo add posthog https://posthog.github.io/charts-clickhouse/
helm repo update
helm install -f values.yaml --timeout 20m --create-namespace --namespace posthog posthog posthog/posthog
```

### Set up a static IP

1. Open the Google Cloud Console
1. Go to VPC Networks > [External IP addresses](https://console.cloud.google.com/networking/addresses/list)
1. Add new static IP with the name `posthog`

After the chart has started, you can look up the external ip via the following command:

```bash
kubectl get svc posthog --namespace posthog
```

### Setting up DNS

Create a `CNAME` record from your desired hostname to the external IP.

### I cannot connect to my PostHog instance after creation

If DNS has been updated properly, check whether the SSL certificate was created successfully.

This can be done via the following command:

```bash
gcloud beta --project yourproject compute ssl-certificates list
```

If running the command shows the SSL cert as `PROVISIONING`, that means that the certificate is still being created. [Read more on how to troubleshoot Google SSL certificates here](https://cloud.google.com/load-balancing/docs/ssl-certificates/troubleshooting)

As a troubleshooting tool, you can allow HTTP access by setting `ingress.gcp.forceHttps` and `web.secureCookies` both to false, but we recommend always accessing PostHog via https.

### How can I connect to my ClickHouse instance?

- Get the IP via `kubectl get svc --namespace posthog`
- Username: `admin` or `clickhouse.user`
- Password: `clickhouse.password`


</details>

<details>
  <summary>
    <b>AWS</b>
  </summary>
<br />

First we need to set up a Kubernetes Cluster, see [Setup EKS - eksctl](https://docs.aws.amazon.com/eks/latest/userguide/getting-started-eksctl.html).

Here's the minimal required `values.yaml` that we'll be using later. You can find an overview of the parameters that can be configured during installation under [configuration](#configuration).
```yaml
cloud: "aws"
ingress:
  hostname: <your-hostname>
  nginx:
    enabled: true
certManager:
  enabled: true
```

### Installing the chart

To install the chart with the release name `posthog` in `posthog` namespace, run the following:

```console
helm repo add posthog https://posthog.github.io/charts-clickhouse/
helm repo update
helm install -f values.yaml --timeout 20m --create-namespace --namespace posthog posthog posthog/posthog
```
    
### Lookup external IP

```bash
kubectl get svc --namespace posthog posthog-ingress-nginx-controller
```
### Setting up DNS

Create a `CNAME` record from your desired hostname to the external IP.

### I cannot connect to my PostHog instance after creation
As a troubleshooting tool, you can allow HTTP access by setting these values in your `values.yaml`, but we recommend always accessing PostHog via https.
```
ingress:
  redirectToTLS: false
  letsencrypt: false
web:
  secureCookies: false
```
</details>

<details>
  <summary>
    <b>Digital Ocean</b>
  </summary>
<br />
Note that there is a [1-click option to deploy Posthog](https://marketplace.digitalocean.com/apps/posthog-1) on DigitalOcean.
First we need to set up a Kubernetes Cluster, see [Kubernetes quickstart](https://docs.digitalocean.com/products/kubernetes/quickstart/). Note that the minimum resource requirements to run Posthog are 4vcpu and 4Gi of memory. 

Here's the minimal required `values.yaml` that we'll be using later. You can find an overview of the parameters that can be configured during installation under [configuration](#configuration).
```yaml
cloud: "do"
ingress:
  hostname: <your-hostname>
  nginx:
    enabled: true
certManager:
  enabled: true
```

### Installing the chart

To install the chart with the release name `posthog` in `posthog` namespace, run the following:

```console
helm repo add posthog https://posthog.github.io/charts-clickhouse/
helm repo update
helm install -f values.yaml --timeout 20m --create-namespace --namespace posthog posthog posthog/posthog
```

### Lookup external IP

```bash
kubectl get svc --namespace posthog posthog-ingress-nginx-controller
```
### Setting up DNS

Create a `CNAME` record from your desired hostname to the external IP.

### I cannot connect to my PostHog instance after creation
As a troubleshooting tool, you can allow HTTP access by setting these values in your `values.yaml`, but we recommend always accessing PostHog via https.
```
ingress:
  redirectToTLS: false
  letsencrypt: false
web:
  secureCookies: false
```
</details>

<details>
  <summary>
    <b>Other using nginx ingress controller</b>
  </summary>
<br />

Here's the minimal required `values.yaml` that we'll be using later. You can find an overview of the parameters that can be configured during installation under [configuration](#configuration).
```yaml
ingress:
  hostname: <your-hostname>
```

### Lookup external IP

```bash
kubectl get svc --namespace posthog posthog-ingress-nginx-controller
```
### Setting up DNS

Create a `CNAME` record from your desired hostname to the external IP.
### I cannot connect to my PostHog instance after creation
As a troubleshooting tool, you can allow HTTP access by setting these values in your `values.yaml`, but we recommend always accessing PostHog via https.
```
ingress:
  redirectToTLS: false
  letsencrypt: false
web:
  secureCookies: false
```

### Installing the chart

To install the chart with the release name `posthog` in `posthog` namespace, run the following:

```console
helm repo add posthog https://posthog.github.io/charts-clickhouse/
helm repo update
helm install -f values.yaml --timeout 20m --create-namespace --namespace posthog posthog posthog/posthog
```
</details>

## Upgrading the chart

```console
helm repo update
helm upgrade -f values.yaml --timeout 20m --namespace posthog posthog posthog/posthog
```

> See [the Helm docs](https://helm.sh/docs/helm/helm_upgrade/) for documentation on the `helm upgrade` command.

When upgrading major versions, see [Upgrade notes](#upgrade-notes)


## Uninstalling the Chart

```console
$ helm uninstall posthog --namespace posthog
```

> See [the Helm docs](https://helm.sh/docs/helm/helm_uninstall/) for documentation on the `helm uninstall` command.

The command above removes all the Kubernetes components associated with the chart and deletes the release.

## Dependencies

By default, the chart installs the following dependencies:

- [Altinity/clickhouse-operator](https://github.com/Altinity/clickhouse-operator/)
- [bitnami/postgresql](https://github.com/bitnami/charts/tree/master/bitnami/postgresql)
- [bitnami/redis](https://github.com/bitnami/charts/tree/master/bitnami/redis)
- [bitnami/kafka](https://github.com/bitnami/charts/tree/master/bitnami/kafka)

There is optional support for the following additional dependencies:

- [kubernetes/ingress-nginx](https://github.com/kubernetes/ingress-nginx/)
- [jetstack/cert-manager](https://github.com/jetstack/cert-manager)
- [prometheus-community/prometheus](https://github.com/prometheus-community/helm-charts/tree/main/charts/prometheus)
- [prometheus-community/prometheus-statsd-exporter](https://github.com/prometheus-community/helm-charts/tree/main/charts/prometheus-statsd-exporter)

See [configuration](#configuration) section for how to enable and configure each.

## Configuration

Dependent charts can also have values overwritten. Preface values with postgresql.*, see options for each chart in [ALL_VALUES.md](ALL_VALUES.md) or under each charts repos in [Dependencies](#Dependencies).

All configuration options can be found in [ALL_VALUES.md](ALL_VALUES.md) or in [values.yaml](values.yaml) file.

### Setting up email
Outgoing email is use for password reset for example. For posthog to be able to send emails we need a login and password. Add these settings to your `values.yaml`:
```
email:
  user: <your STMP login user>
  password:  <your STMP password>
```

### Scaling up
The default configuration is geared towards minimizing costs. Here are example extra values overrides to use for scaling up:
<details>
  <summary>
    <b> Additional values to `values.yaml` for <1M events/month</b>
  </summary>

<br />

```yaml
# Note that this is experimental, please let us know how this worked for you.

# More storage space
clickhouseOperator:
  storage: 60Gi

postgresql:
  persistence:
    size: 20Gi

redis:
  master:
    size: 10Gi

kafka:
  persistence:
    size: 10Gi
  logRetentionBytes: _8_000_000_000

# Extra replicas for more loaded services
web:
  replicacount: 2

worker:
  replicacount: 2

plugins:
  replicacount: 2
```

</details>

<details>
  <summary>
    <b> Additional values to `values.yaml` for >1M events/month</b>
  </summary>

<br />

```yaml
# Note that this is experimental, please let us know how this worked for you.

# More storage space
clickhouseOperator:
  storage: 200Gi

postgresql:
  persistence:
    size: 60Gi

redis:
  master:
    size: 30Gi

kafka:
  persistence:
    size: 30Gi
  logRetentionBytes: _22_000_000_000

# Enable horizontal autoscaling for serivces
pgbouncer:
  hpa:
    enabled: true

web:
  hpa:
    enabled: true

beat:
  hpa:
    enabled: true

worker:
  hpa:
    enabled: true

plugins:
  hpa:
    enabled: true
```

</details>

### [ClickHouse](https://clickhouse.tech/)

TODO

### [PostgreSQL](https://www.postgresql.org/)

> While ClickHouse powers the bulk of the analytics if you deploy PostHog using this chart, Postgres is still needed as a data store for PostHog to work.

By default, PostgreSQL is installed as part of the chart. To use an external PostgreSQL server set `postgresql.enabled` to `false` and then set `postgresql.postgresHost` and `postgresql.postgresqlPassword`. The other options (`postgresql.postgresqlDatabase`, `postgresql.postgresqlUsername` and `postgresql.postgresqlPort`) may also want changing from their default values.

To avoid issues when upgrading this chart, provide `postgresql.postgresqlPassword` for subsequent upgrades. This is due to an issue in the PostgreSQL chart where password will be overwritten with randomly generated passwords otherwise. See https://github.com/helm/charts/tree/master/stable/postgresql#upgrade for more detail.

### [Redis](https://redis.io/)

By default, Redis is installed as part of the chart. To use an external Redis server/cluster set `redis.enabled` to `false` and then set `redis.host`. If your redis cluster uses password define it with `redis.password`, otherwise just omit it. Check the table above for more configuration options.

To avoid issues when upgrading this chart, provide `redis.password` for subsequent upgrades. Otherwise the redis pods will get recreated on every update, potentially incurring some downtime.

_See [ALL_VALUES.md](ALL_VALUES.md) and [redis chart](https://github.com/bitnami/charts/tree/master/bitnami/redis) for full configuration options._

### [Kafka](https://kafka.apache.org/)

TODO

### [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/)

This chart provides support for Ingress resource. By default nginx ingress is enabled (it can be disabled by setting `ingress.nginx.enabled` to false. You maybe want to set an `ingress.hostname` and set up DNS to be able to access the installation using that URL.

### [Prometheus](https://prometheus.io/docs/introduction/overview/)

This chart supports alerting. Set `prometheus.enabled` to true and set `prometheus.alertmanagerFiles` to the right configuration.

Read more at https://github.com/prometheus-community/helm-charts/tree/main/charts/prometheus and https://prometheus.io/docs/alerting/latest/configuration/

#### Example configuration ([PagerDuty](https://www.pagerduty.com/))

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

#### Getting access to the Prometheus UI

This might be useful when checking out metrics. Figure out your `prometheus-server` pod name via `kubectl get pods --namespace NS` and run:
`kubectl --namespace NS port-forward posthog-prometheus-server-XXX 9090`.

After this you should be able to access prometheus server on `localhost`.

### Hosting costs

Charges on various platforms can be confusing to understand as loadbalancers (which the default configuration has 3) and storage (default configuration has 40Gi) are often charged separately from compute.

</details>

<details>
  <summary>
    <b>DigitalOcean (74$/month)</b>
  </summary>

<br />

See [DigitalOcean Kubernetes pricing](https://www.digitalocean.com/pricing#kubernetes).
At the time of writing the default setup comes around 
40$ (2x smalles prod nodes) + 30$ (3x small load balancers) + 4$ (40Gi block storage) = 74$ / month

</details>


### Releasing a new version of this helm chart

Simply apply one of the following labels to your PR _before merging_ to bump the version and release it to the helm repo:
- `bump patch`
- `bump minor`
- `bump major`

## Upgrade notes

### Upgrading from 1.x.x

2.0.0 updated redis chart in an incompatible way. If your upgrade fails with

```
Upgrade "posthog" failed: cannot patch "posthog-posthog-redis-master" with kind StatefulSet: StatefulSet.apps "posthog-posthog-redis-master" is invalid: spec: Forbidden: updates to statefulset spec for fields other than 'replicas', 'template', and 'updateStrategy' are forbidden
```

Run the following and `helm upgrade` again: `kubectl delete --namespace NAMESPACE sts posthog-posthog-redis-master`
