# ⚠️ PostHog no longer supports Kubernetes deployments. ⚠️ 

**As of May 2023, [PostHog no longer support Kubernetes deployments](https://posthog.com/blog/sunsetting-helm-support-posthog).** This decision doesn't impact open source ("Hobby") users on [Docker Compose deployments](https://posthog.com/docs/self-host). 

## What's next?

To continue using PostHog, you have two options:

### Using PostHog Cloud (Recommended)
We strongly encourage users to move to PostHog Cloud wherever possible so that they always have the latest features and the full benefit of official support. It usually works out much cheaper, too. 

PostHog Cloud is SOC 2 compliant and available with either EU or US hosting options. If you already have a self-hosted instance, you can [migrate to PostHog Cloud](https://posthog.com/docs/migrate/migrate-between-posthog-instances). Alternatively, you can choose to [migrate to a open source deployment](https://posthog.com/docs/self-host/open-source/deployment) instead. 

### Self-hosting PostHog
If you want to continue using a self-hosted PostHog deployment then you do so without support. 

We **strongly recommend** following the [official instructions](https://posthog.com/docs/self-host) to deploy PostHog if you must self-host. Most people who modify or use a non-standard way of running this chart run into issues, which we are unable to help with. 

Security updates will continue until May 2024.

# PostHog Helm Chart

[![Latest release of the Helm chart](https://img.shields.io/badge/dynamic/yaml.svg?label=Helm%20chart%20version&url=https://posthog.github.io/charts-clickhouse/index.yaml&query=$.entries.posthog[:1].version&logo=helm)](https://github.com/PostHog/charts-clickhouse)
[![Latest release app version](https://img.shields.io/badge/dynamic/yaml.svg?label=App%20version&url=https://posthog.github.io/charts-clickhouse/index.yaml&query=$.entries.posthog[:1].appVersion)](https://github.com/PostHog/posthog)
[![MIT License](https://img.shields.io/badge/License-MIT-red.svg?style=flat-square)](https://opensource.org/licenses/MIT)
[![Community](https://img.shields.io/badge/PostHog_chat-slack-blue?logo=slack)](https://posthog.com/questions)

-----

🦔 [PostHog](https://posthog.com/) is a developer-friendly, open-source product analytics suite.

This Helm chart bootstraps a [PostHog](https://posthog.com/) installation on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites
- Kubernetes >=1.24 <= 1.26
- Helm >= 3.7.0

## Installation
Deployment instructions for the major cloud service providers and on-premise deploys are available [here](https://posthog.com/docs/self-host).

## Changelog
We documented detailed changes for each major release in our [upgrade notes](https://posthog.com/docs/self-host/deploy/upgrade-notes).

## Development
We welcome all contributions to the community, but no longer offer any support. 

### Testing
This repo uses several types of test suite targeting different goals:

- **lint tests**: to verify if the Helm templates can be rendered without errors
- **unit tests**: to verify if the rendered Helm templates are as we expect
- **integration tests**: to verify if applying the rendered Helm templates against a Kubernetes target cluster gives us the stack and PostHog installation we expect

#### Lint tests
We use `helm lint` that can be invoked via: `helm lint --strict --set "cloud=local" charts/posthog`

#### Unit tests
In order to run the test suite, you need to install the `helm-unittest` plugin. You can do that by running: `helm plugin install https://github.com/quintush/helm-unittest --version 0.2.8`

For more information about how it works and how to write test cases, please look at the upstream [documentation](https://github.com/quintush/helm-unittest/blob/master/README.md) or to the [tests already available in this repo](https://github.com/PostHog/charts-clickhouse/tree/main/charts/posthog/tests).

To run the test suite you can execute: `helm unittest --helm3 --strict --file 'tests/*.yaml' --file 'tests/clickhouse-operator/*.yaml' charts/posthog`

If you need to update the snapshots, execute:

```
helm unittest --helm3 --strict --file 'tests/*.yaml' --file 'tests/**/*.yaml' charts/posthog -u
```

#### Integration tests
- [kubetest](https://github.com/PostHog/charts-clickhouse/tree/main/ci/kubetest): to verify if applying the rendered Helm templates against a Kubernetes target cluster gives us the stack we expect (example: are the disks encrypted? Can this pod communicate with this service?)
- [k6](https://github.com/PostHog/charts-clickhouse/tree/main/ci/k6): HTTP test used to verify the reliability, performance and compliance of the PostHog installation (example: is the PostHog ingestion working correctly?)
- [e2e - k3s](https://github.com/PostHog/charts-clickhouse/tree/main/.github/workflows/test-helm-chart.yaml): to verify Helm install/upgrade commands on a local k3s cluster
- [e2e - Amazon Web Services](https://github.com/PostHog/charts-clickhouse/tree/main/.github/workflows/test-amazon-web-services-install.yaml), [e2e - DigitalOcean](https://github.com/PostHog/charts-clickhouse/tree/main/.github/workflows/test-digitalocean-install.yaml), [e2e - Google Cloud Platform](https://github.com/PostHog/charts-clickhouse/tree/main/.github/workflows/test-google-cloud-platform-install.yaml): to verify Helm install command on the officially supported cloud platforms


### Running k3s for tests locally

k6 test is using [k3s](https://k3s.io/) for running things on localhost, which might be tricky to get running locally. Here's one method:

```bash
# Install k3s without system daemon
curl -sfL https://get.k3s.io | INSTALL_K3S_SKIP_ENABLE=true sh
# Once done run k3s manually, disabling conflicting services
sudo k3s server --write-kubeconfig-mode 644 --disable traefik --docker --disable-network-policy

# Deploy the chart
helm upgrade --install -f ci/values/k3s.yaml --timeout 20m --create-namespace --namespace posthog posthog ./charts/posthog --wait --wait-for-jobs --debug

# Once done, prepare the data/environment
./ci/setup_ingestion_test.sh

export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
export POSTHOG_API_ADDRESS=$(kubectl get svc -n posthog posthog-web -o jsonpath="{.spec.clusterIP}")
export POSTHOG_EVENTS_ADDRESS=$(kubectl get svc -n posthog posthog-events -o jsonpath="{.spec.clusterIP}")
export "POSTHOG_API_ENDPOINT=http://${POSTHOG_API_ADDRESS}:8000"
export "POSTHOG_EVENT_ENDPOINT=http://${POSTHOG_EVENTS_ADDRESS}:8000"
export "SKIP_SOURCE_IP_ADDRESS_CHECK=true"

# Run test
k6 run ci/k6/ingestion-test.js
```

### Release

To release a new chart, bump the `version` in `charts/posthog/Chart.yaml`. We use [Semantic Versioning](https://semver.org/):

    MAJOR version when you make incompatible API changes
    MINOR version when you add functionality in a backwards compatible manner
    PATCH version when you make backwards compatible bug fixes

Read API here as the chart values interface. When increasing the MAJOR version, ensure to add
appropriate documentation to the [Upgrade notes](https://posthog.com/docs/runbook/upgrade-notes).

Charts are [published on push](https://github.com/PostHog/charts-clickhouse/blob/main/.github/workflows/release-chart.yml)
to the `main` branch.

Note that development charts are also released on PRs such that changes can be tested as required
before merge, e.g. changing staging/dev to use the chart for more end to end validation.
