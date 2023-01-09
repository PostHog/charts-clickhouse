import pytest

from helpers.clickhouse import get_clickhouse_pod_spec
from helpers.utils import install_chart, is_posthog_healthy, wait_for_pods_to_be_ready

# Setting a value for the tag here to 22.8.11.15-alpine
# This version because it will be compatible going forward after we
# require 22.3 for JSON Object datatype support
# This tests to make sure that when specified clickhouse-operator
# actually uses the image that you give it vs. some other tag that it
# determines that it wants to pull.
VALUES_WITH_DIFFERENT_CLICKHOUSE_IMAGE = """
cloud: "local"

clickhouse:
  image:
    tag: 22.8.11.15-alpine
"""


def test_clickhouse_pod_image(kube):
    install_chart(VALUES_WITH_DIFFERENT_CLICKHOUSE_IMAGE)
    wait_for_pods_to_be_ready(kube)

    is_posthog_healthy(kube)
    pod_spec = get_clickhouse_pod_spec(kube)
    assert (
        pod_spec.containers[0].image == "clickhouse/clickhouse-server:22.8.11.15-alpine"
    )
