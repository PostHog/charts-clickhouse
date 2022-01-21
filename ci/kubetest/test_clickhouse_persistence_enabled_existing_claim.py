import logging
import subprocess

import pytest
from kubernetes import client

from utils import NAMESPACE, cleanup_k8s, get_clickhouse_statefulset_spec, helm_install, wait_for_pods_to_be_ready

logging.basicConfig(level=logging.DEBUG)
log = logging.getLogger()

HELM_INSTALL_CMD = """
helm upgrade \
    --install \
    -f ../../ci/values/kubetest/test_clickhouse_persistence_enabled_existing_claim.yaml \
    --timeout 30m \
    --create-namespace \
    --namespace posthog \
    posthog ../../charts/posthog \
    --wait-for-jobs \
    --wait
"""


def create_custom_pvc():
    log.debug("🔄 Creating a custom Persistent Volume Claim...")
    cmd = "kubectl apply -n {namespace} -f clickhouse_existing_claim.yaml".format(namespace=NAMESPACE)
    cmd_run = subprocess.run(cmd, shell=True)
    cmd_return_code = cmd_run.returncode
    if cmd_return_code:
        pytest.fail("❌ Error while running '{}'. Return code: {}".format(cmd, cmd_return_code))
    log.debug("✅ Done!")


@pytest.fixture
def setup(kube):
    cleanup_k8s()
    create_custom_pvc()
    helm_install(HELM_INSTALL_CMD)
    wait_for_pods_to_be_ready(kube)


def test_helm_install(setup, kube):
    pass


def test_volume_claim(kube):
    statefulset_spec = get_clickhouse_statefulset_spec(kube)

    # Verify the spec.volumes configuration
    volumes = statefulset_spec.template.spec.volumes
    expected_volume = client.V1Volume(
        name="existing-volumeclaim",
        persistent_volume_claim=client.V1PersistentVolumeClaimVolumeSource(
            claim_name="custom-pvc",
        ),
    )
    assert expected_volume in volumes, "spec.volumes should include {}".format(expected_volume)

    # Verify the spec.containers.[].volumeMounts
    volume_mounts = statefulset_spec.template.spec.containers[0].volume_mounts
    expected_volume_mount = client.V1VolumeMount(name="existing-volumeclaim", mount_path="/var/lib/clickhouse")
    assert expected_volume_mount in volume_mounts, "spec.containers.[].volumeMounts should include {}".format(
        expected_volume_mount
    )
