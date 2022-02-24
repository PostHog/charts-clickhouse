import pytest
import yaml

from helpers.clickhouse import get_clickhouse_table_counts_on_all_nodes
from helpers.utils import cleanup_helm, cleanup_k8s, install_chart, is_posthog_healthy, wait_for_pods_to_be_ready

# :KLUDGE: There's unrelated code here that can be removed long-term once:
#   - https://github.com/PostHog/posthog/pull/8730 is merged (custom image)
#   - We've removed the need for CLICKHOUSE_REPLICATION under https://github.com/PostHog/posthog/issues/8652
VALUES_WITH_SHARDING = """
cloud: "local"

image:
  repository: macobo/posthog-test
  sha: sha256:0148396b08058b33918ed1f38f095d7e2970774cdeb93fbb6d6fe9db781eec67

env:
- name: CLICKHOUSE_REPLICATION
  value: "true"

clickhouse:
  user: posthog
  password: kubetest123
  layout:
    shardsCount: 2
    replicasCount: 2
"""


@pytest.fixture(autouse=True)
def setup(kube):
    cleanup_k8s()
    cleanup_helm()
    install_chart(VALUES_WITH_SHARDING)
    wait_for_pods_to_be_ready(kube)


def test_posthog_healthy(kube):
    is_posthog_healthy(kube)


def test_shards_are_properly_set_up(kube):
    number_of_hosts, table_counts = get_clickhouse_table_counts_on_all_nodes(kube)

    assert number_of_hosts == 4
    assert len(set(table_counts)) == 1, "Schemas on some ClickHouse nodes are out of sync"

    # table count as of 2022.02.24
    assert table_counts[0] >= 31


def test_upgrading_to_more_shards(kube):
    # Upgrade to 6 nodes in total (3 * 2)
    new_values = yaml.safe_load(VALUES_WITH_SHARDING)
    new_values["clickhouse"]["layout"]["shardsCount"] = 3

    install_chart(new_values)
    wait_for_pods_to_be_ready(
        kube,
        labels={
            "clickhouse.altinity.com/namespace": "posthog",
            "clickhouse.altinity.com/chi": "posthog",
        },
        expected_count=6,
    )

    # Validate the ClickHouse node setup
    number_of_hosts, table_counts = get_clickhouse_table_counts_on_all_nodes(kube)
    assert number_of_hosts == 6
    assert len(set(table_counts)) == 1, "Schemas on some ClickHouse nodes are out of sync"
    assert table_counts[0] >= 31
