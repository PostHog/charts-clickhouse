import pytest

from helpers.clickhouse import get_clickhouse_cluster_service_spec
from helpers.utils import (
    VALUES_DISABLE_EVERYTHING,
    create_namespace_if_not_exists,
    install_chart,
    is_posthog_healthy,
    merge_yaml,
    wait_for_pods_to_be_ready,
)

VALUES = merge_yaml(
    VALUES_DISABLE_EVERYTHING,
    """
    clickhouse:
      enabled: true
    """,
)


def test_default_service_type(kube):
    create_namespace_if_not_exists()
    install_chart(VALUES)
    wait_for_pods_to_be_ready(kube)

    cluster_service = get_clickhouse_cluster_service_spec(kube)
    assert cluster_service.type == "ClusterIP", "ClickHouse cluster service type is {}".format(cluster_service.type)
