import pytest

from utils import cleanup_k8s, get_clickhouse_statefulset_spec, helm_install, wait_for_pods_to_be_ready

HELM_INSTALL_CMD = """
helm upgrade \
    --install \
    -f ../../ci/values/kubetest/test_clickhouse_persistence_disabled.yaml \
    --timeout 30m \
    --create-namespace \
    --namespace posthog \
    posthog ../../charts/posthog \
    --wait-for-jobs \
    --wait
"""


@pytest.fixture
def setup(kube):
    cleanup_k8s()
    helm_install(HELM_INSTALL_CMD)
    wait_for_pods_to_be_ready(kube)


def test_volume_claim(setup, kube):
    statefulset_spec = get_clickhouse_statefulset_spec(kube)

    # Verify the spec.volumes configuration
    volumes = statefulset_spec.template.spec.volumes
    assert all(volume.config_map is not None for volume in volumes), "All the spec.volumes should be of type config_map"
