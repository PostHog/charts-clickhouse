import time

import pytest
import yaml

from helpers.clickhouse import get_clickhouse_table_counts_on_all_nodes
from helpers.utils import cleanup_helm, cleanup_k8s, install_chart, wait_for_pods_to_be_ready

VALUES_WITH_SHARDING = """
cloud: "local"

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


# I've disabled this for now, on bringing up the 5th clickhouse node it appears
# we get:
#
# │ E0630 09:54:06.695617       1 connection.go:184] Exec():FAILED Exec(http://***:***@chi-posthog-posthog-2-0.posthog.svc.clust │
# │  for SQL: CREATE TABLE IF NOT EXISTS posthog.sharded_session_recording_events (`uuid` UUID, `timestamp` DateTime64(6, 'UTC') │
# │ I0630 09:54:06.695646       1 retry.go:48] exec():chi-posthog-posthog-2-0.posthog.svc.cluster.local:FAILED attempt 2 of 10,  │
#
# I don't think this ever worked, but this was being masked by the issue that
# there was a fixture that was being initialized for each test_ hence we were
# just testing that we could perform the initial install with more shards.
@pytest.skip("Broken, clickhouse-operator fails to replicate tables to new shards")
def test_upgrading_to_more_shards(kube):
    cleanup_k8s()
    cleanup_helm()
    install_chart(VALUES_WITH_SHARDING)
    wait_for_pods_to_be_ready(kube)

    number_of_hosts, table_counts = get_clickhouse_table_counts_on_all_nodes(kube)

    assert number_of_hosts == 4
    assert len(set(table_counts)) == 1, "Schemas on some ClickHouse nodes are out of sync"

    # table count as of 2022.02.24
    assert table_counts[0] >= 31

    # Upgrade to 6 nodes in total (3 * 2)
    new_values = yaml.safe_load(VALUES_WITH_SHARDING)
    new_values["clickhouse"]["layout"]["shardsCount"] = 3

    install_chart(new_values)

    # Wait for new replicas to come up and for tables to be created
    start = time.time()
    while time.time() - start < 120:
        number_of_hosts, table_counts = get_clickhouse_table_counts_on_all_nodes(kube)
        if number_of_hosts == 6 and len(set(table_counts)) == 1:
            break

        time.sleep(5)

    assert number_of_hosts == 6
    assert len(set(table_counts)) == 1, "Schemas on some ClickHouse nodes are out of sync"
    assert table_counts[0] >= 31
