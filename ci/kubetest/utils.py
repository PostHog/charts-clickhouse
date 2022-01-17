import logging
import subprocess
import time

import pytest

logging.basicConfig(level=logging.DEBUG)
log = logging.getLogger()

NAMESPACE = "posthog"


def cleanup_k8s():
    log.debug("🔄 Setting up the k8s cluster...")
    cmd = "kubectl delete all --all -n {namespace}".format(namespace=NAMESPACE)
    cmd_run = subprocess.run(cmd, shell=True)
    cmd_return_code = cmd_run.returncode
    if cmd_return_code:
        pytest.fail("❌ Error while running '{}'. Return code: {}".format(cmd, cmd_return_code))
    log.debug("✅ Done!")


def helm_install(HELM_INSTALL_CMD):
    log.debug("🔄 Deploying PostHog...")
    cmd = HELM_INSTALL_CMD
    cmd_run = subprocess.run(cmd, shell=True)
    cmd_return_code = cmd_run.returncode
    if cmd_return_code:
        pytest.fail("❌ Error while running '{}'. Return code: {}".format(cmd, cmd_return_code))
    log.debug("✅ Done!")


def wait_for_pods_to_be_ready(kube):
    log.debug("🔄 Waiting for all pods to be ready...")
    time.sleep(30)
    start = time.time()
    timeout = 60
    while time.time() < start + timeout:
        pods = kube.get_pods(namespace="posthog")
        for pod in pods.values():
            if not pod.is_ready():
                continue
        break
    else:
        pytest.fail("❌ Timeout raised while waiting for pods to be ready")
    log.debug("✅ Done!")


def get_clickhouse_statefulset_spec(kube):
    statefulsets = kube.get_statefulsets(
        namespace="posthog",
        labels={"clickhouse.altinity.com/namespace": "posthog"},
    )
    statefulset = next(iter(statefulsets.values()))
    return statefulset.obj.spec
