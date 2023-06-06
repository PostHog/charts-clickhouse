import pytest

from helpers.clickhouse import get_clickhouse_pod_spec
from helpers.utils import install_chart, is_posthog_healthy, wait_for_pods_to_be_ready

VALUES_WITH_DIFFERENT_CLICKHOUSE_IMAGE = """
cloud: "local"

clickhouse:
  image:
    tag: 23.4.2.11-alpine
"""


def test_clickhouse_pod_image(kube):
    install_chart(VALUES_WITH_DIFFERENT_CLICKHOUSE_IMAGE)
    wait_for_pods_to_be_ready(kube)

    is_posthog_healthy(kube)
    pod_spec = get_clickhouse_pod_spec(kube)
    assert pod_spec.containers[0].image == "clickhouse/clickhouse-server:23.4.2.11-alpine"
