import pytest

from helpers.clickhouse import get_clickhouse_cluster_service_spec
from helpers.utils import helm_install, is_posthog_healthy, wait_for_pods_to_be_ready

HELM_INSTALL_CMD = """
helm upgrade \
    --install \
    -f ../../ci/values/kubetest/test_clickhouse_service_nodeport.yaml \
    --timeout 30m \
    --create-namespace \
    --namespace posthog \
    posthog ../../charts/posthog \
    --wait-for-jobs \
    --wait
"""


def test_cluster_service(kube):
    helm_install(HELM_INSTALL_CMD)
    wait_for_pods_to_be_ready(kube)

    is_posthog_healthy(kube)
    cluster_service = get_clickhouse_cluster_service_spec(kube)
    assert cluster_service.type == "NodePort", "ClickHouse cluster service type is {}".format(cluster_service.type)
