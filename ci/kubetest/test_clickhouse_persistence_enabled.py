import pytest
from kubernetes import client

from helpers.clickhouse import get_clickhouse_statefulset_spec
from helpers.utils import cleanup_k8s, helm_install, wait_for_pods_to_be_ready

HELM_INSTALL_CMD = """
helm upgrade \
    --install \
    -f ../../ci/values/kubetest/test_clickhouse_persistence_enabled.yaml \
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
    expected_volume = client.V1Volume(
        name="data-volumeclaim-template",
        persistent_volume_claim=client.V1PersistentVolumeClaimVolumeSource(
            claim_name="data-volumeclaim-template",
        ),
    )
    assert expected_volume in volumes, "spec.volumes should include {}".format(expected_volume)

    # Verify the spec.containers.[].volumeMounts
    volume_mounts = statefulset_spec.template.spec.containers[0].volume_mounts
    expected_volume_mount = client.V1VolumeMount(name="data-volumeclaim-template", mount_path="/var/lib/clickhouse")
    assert expected_volume_mount in volume_mounts, "spec.containers.[].volumeMounts should include {}".format(
        expected_volume_mount
    )
