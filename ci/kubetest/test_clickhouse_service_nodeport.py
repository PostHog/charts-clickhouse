import pytest

from helpers.clickhouse import get_clickhouse_cluster_service_spec
from helpers.utils import cleanup_k8s, helm_install, wait_for_pods_to_be_ready

HELM_INSTALL_CMD = """
helm upgrade \
    --install \
    -f ../../ci/values/kubetest/test_clickhouse_service_nodeport.yaml \
    --create-namespace \
    --namespace posthog \
    posthog ../../charts/posthog
"""


def test_cluster_service(kube):
    cleanup_k8s()
    helm_install(HELM_INSTALL_CMD)
    wait_for_pods_to_be_ready(kube)

    cluster_service = get_clickhouse_cluster_service_spec(kube)
    assert cluster_service.type == "NodePort", "ClickHouse cluster service type is {}".format(cluster_service.type)
