# PostHog Helm Chart

[![Latest release of the Helm chart](https://img.shields.io/badge/dynamic/yaml.svg?label=Helm%20chart%20version&url=https://posthog.github.io/charts-clickhouse/index.yaml&query=$.entries.posthog[:1].version&logo=helm)](https://github.com/PostHog/charts-clickhouse)
[![Latest release app version](https://img.shields.io/badge/dynamic/yaml.svg?label=App%20version&url=https://posthog.github.io/charts-clickhouse/index.yaml&query=$.entries.posthog[:1].appVersion)](https://github.com/PostHog/posthog)
[![MIT License](https://img.shields.io/badge/License-MIT-red.svg?style=flat-square)](https://opensource.org/licenses/MIT)
[![Slack](https://img.shields.io/badge/PostHog_chat-slack-blue?logo=slack)](https://posthog.com/slack)

-----

🦔 [PostHog](https://posthog.com/) is developer-friendly, open-source product analytics.

This chart bootstraps a [PostHog](https://posthog.com/) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager. The chart uses the scalable [ClickHouse](https://clickhouse.tech/) database for powering analytics.

See deployment instructions on [posthog.com/docs/self-host](https://posthog.com/docs/self-host).

## Prerequisites
- Kubernetes >=1.20 <= 1.23
- Helm 3+

## Development
Add the Helm repositories:
```
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add kubernetes https://kubernetes.github.io/ingress-nginx
helm repo add jetstack https://charts.jetstack.io
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
```

### Unit tests
In order to run the test suite you need to install the `helm-unittest` plugin. You can do that by running:
```
helm plugin install https://github.com/quintush/helm-unittest
```

For more information about how it works and how to write test cases, please take a look at the upstream [documentation](https://github.com/quintush/helm-unittest/blob/master/README.md).

**Run test suite**
```
helm unittest --helm3 --strict --file 'tests/*.yaml' --file 'tests/**/*.yaml' charts/posthog
```

## Releasing a new version of this helm chart

Simply apply one of the following labels to your PR _before merging_ to bump the version and release it to the helm repo:
- `bump patch`
- `bump minor`
- `bump major`

👋
