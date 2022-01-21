import logging
import subprocess
import time

import pytest

logging.basicConfig(level=logging.DEBUG)
log = logging.getLogger()

NAMESPACE = "posthog"


def cleanup_k8s(namespaces=["default", NAMESPACE]):
    log.debug("🔄 Making sure the k8s cluster is empty...")
    for namespace in namespaces:
        cmd = "kubectl delete all --all -n {namespace}".format(namespace=namespace)
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


def is_posthog_healthy(kube):
    test_if_posthog_deployments_are_healthy(kube)


def test_if_posthog_deployments_are_healthy(kube):
    deployments = kube.get_deployments(
        namespace="posthog",
        labels={"app": "posthog"},
    )
    for deployment_name, deployment in deployments.items():
        # Skip PgBouncer as it's a "snowflake" deployment
        # we should use a 3rd party chart for it
        if "pgbouncer" in deployment_name:
            continue
        assert deployment.is_ready(), "Deployment {} is not ready".format(deployment_name)

        pods = deployment.get_pods()
        for pod in pods:
            assert pod.is_ready(), "Pod {} of deployment {} is not ready".format(pod.name, deployment_name)


def create_namespace_if_not_exists(name="posthog"):
    log.debug("🔄 Creating namespace {} (if not exists)...".format(name))
    cmd = "kubectl create namespace {} --dry-run=client -o yaml | kubectl apply -f -".format(name)
    cmd_run = subprocess.run(cmd, shell=True)
    cmd_return_code = cmd_run.returncode
    if cmd_return_code:
        pytest.fail("❌ Error while running '{}'. Return code: {}".format(cmd, cmd_return_code))
    log.debug("✅ Done!")


def install_custom_resources(filename, namespace="posthog"):
    log.debug("🔄 Setting up custom resources for this test...")
    cmd = "kubectl apply -n {namespace} -f {filename}".format(namespace=namespace, filename=filename)
    cmd_run = subprocess.run(cmd, shell=True)
    cmd_return_code = cmd_run.returncode
    if cmd_return_code:
        pytest.fail("❌ Error while running '{}'. Return code: {}".format(cmd, cmd_return_code))
    log.debug("✅ Done!")
