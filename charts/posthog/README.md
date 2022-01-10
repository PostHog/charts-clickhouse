# PostHog Helm Chart

[![Latest release of the Helm chart](https://img.shields.io/badge/dynamic/yaml.svg?label=Helm%20chart%20version&url=https://posthog.github.io/charts-clickhouse/index.yaml&query=$.entries.posthog[:1].version&logo=helm)](https://github.com/PostHog/charts-clickhouse)
[![Latest release app version](https://img.shields.io/badge/dynamic/yaml.svg?label=App%20version&url=https://posthog.github.io/charts-clickhouse/index.yaml&query=$.entries.posthog[:1].appVersion)](https://github.com/PostHog/posthog)
[![MIT License](https://img.shields.io/badge/License-MIT-red.svg?style=flat-square)](https://opensource.org/licenses/MIT)
[![Slack](https://img.shields.io/badge/PostHog_chat-slack-blue?logo=slack)](https://posthog.com/slack)

-----

🦔 [PostHog](https://posthog.com/) is a developer-friendly, open-source product analytics suite.

This Helm chart bootstraps a [PostHog](https://posthog.com/) installation on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites
- Kubernetes >=1.20 <= 1.23
- Helm 3+

## Installation
Deployment instructions for the major cloud service providers and on-premise deploys are available [here](https://posthog.com/docs/self-host).

## Changelog
We document detailed changes for each major release in the [upgrade notes](https://posthog.com/docs/self-host/deploy/upgrade-notes).

## Development
The main purpose of this repository is to continue evolving our Helm chart, making it faster and easier to use. We welcome all contributions to the community and are excited to welcome you aboard.

### Testing
This repo uses several types of test suite targeting different goals:

- **lint tests**: to verify if the Helm templates can be rendered without errors
- **unit tests**: to verify if the rendered Helm templates are as we expect
- **integration tests**: to verify if applying the rendered Helm templates against a Kubernetes target cluster gives us the stack and PostHog installation we expect

#### Lint tests
We use `helm lint` that can be invoked via: `helm lint --strict --set “cloud=local” charts/posthog`

#### Unit tests
In order to run the test suite, you need to install the `helm-unittest` plugin. You can do that by running: `helm plugin install https://github.com/quintush/helm-unittest`

For more information about how it works and how to write test cases, please look at the upstream [documentation](https://github.com/quintush/helm-unittest/blob/master/README.md) or to the [tests already available in this repo](./charts/posthog/tests).

To run the test suite you can execute: `helm unittest --helm3 --strict --file ‘tests/*.yaml’ --file ‘tests/**/*.yaml’ charts/posthog`

#### Integration tests
- [Kubetest](./ci/kubetest): to verify if applying the rendered Helm templates against a Kubernetes target cluster gives us the stack we expect (example: are the disks encrypted? Can this pod communicate with this service?)
- [k6](./ci/k6): HTTP test used to verify the reliability, performance and compliance of the PostHog installation (example: is the PostHog ingestion working correctly?)
- [e2e - k3s](.github/workflows/test-helm-chart.yaml): to verify Helm install/upgrade commands on a local k3s cluster
- [e2e - Amazon Web Services](.github/workflows/test-amazon-web-services-install.yaml), [e2e - DigitalOcean](.github/workflows/test-digitalocean-install.yaml), [e2e - Google Cloud Platform](.github/workflows/test-google-cloud-platform-install.yaml): to verify Helm install command on the officially supported cloud platforms

### Release
Add one of the following labels to your PR _before merging_ to bump the version and release it to the Helm repository:

- `bump patch`
- `bump minor`
- `bump major`
