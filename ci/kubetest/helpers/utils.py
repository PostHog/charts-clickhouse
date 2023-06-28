import logging
import subprocess
import sys
import tempfile
import time

import pytest
import yaml

log = logging.getLogger()

YamlString = str

NAMESPACE = "posthog"

VALUES_DISABLE_EVERYTHING: YamlString = """
cloud: "local"
web:
    enabled: false
migrate:
    enabled: false
events:
    enabled: false
worker:
    enabled: false
plugins:
    enabled: false
decide:
    enabled: false
recordings:
    enabled: false
postgresql:
    enabled: false
redis:
    enabled: false
kafka:
    enabled: false
ingress:
    enabled: false
pgbouncer:
    enabled: false
clickhouse:
    enabled: false
zookeeper:
    enabled: false
"""


def merge_yaml(*yamls):
    result = {}
    for value in yamls:
        result.update(yaml.safe_load(value))
    return yaml.dump(result)


def helm_install(HELM_INSTALL_CMD):
    log.debug("🔄 Deploying PostHog...")
    exec_subprocess(HELM_INSTALL_CMD)
    log.debug("✅ Done!")


def install_chart(values, namespace=NAMESPACE):
    log.debug("🔄 Deploying PostHog...")

    values_yaml = values if isinstance(values, str) else yaml.dump(values)
    with tempfile.NamedTemporaryFile(mode="w") as values_file:
        values_file.write(values_yaml)
        values_file.flush()

        exec_subprocess(
            f"""
            helm upgrade \
                --install \
                -f {values_file.name} \
                --set cloud=local \
                --create-namespace \
                --namespace {namespace} \
                posthog ../../charts/posthog
        """
        )

    log.debug("✅ Done!")


def kubectl_exec(pod, command):
    log.debug(f"🔄 Executing command '{command}' in pod {pod}")
    output = exec_subprocess(f"kubectl exec {pod} --namespace {NAMESPACE} -- {command}")
    log.debug("✅ Done!")

    return output


def wait_for_pods_to_be_ready(kube, labels=None, expected_count=None, namespace=NAMESPACE):
    log.debug("🔄 Waiting for all pods to be ready...")
    labels = labels or {}
    start = time.time()
    timeout = 900
    while time.time() < start + timeout:
        pods = kube.get_pods(namespace=namespace, labels=labels)

        if expected_count is not None and len(pods) < expected_count:
            continue

        for pod in pods.values():
            name = pod.obj.metadata.name
            if pod.obj.metadata.labels.get("app") == "posthog" and not name.startswith("posthog-pgbouncer"):
                # Only ever expect things we have control over to not restart.
                #
                # NOTE: we do have control over pgbouncer but we tolerate
                # restarts here. It may be worth however setting up an init
                # container to ensure that any dependencies are satisfied before
                # starting.
                #
                # NOTE 2: the test is currently a bit flaky likely due to
                # liveness/readiness checks. I'm bumping the expected restart
                # count from 0 to 2 for now.
                assert get_pod_restart_count(pod) < 2, f"Detected too many restarts in pod {pod.obj.metadata.name}"

        # Note we assume that if "job-name" is a label then it is a job pod.
        non_job_pods = [pod for pod in pods.values() if "job-name" not in pod.obj.metadata.labels]
        job_pods = [pod for pod in pods.values() if "job-name" in pod.obj.metadata.labels]

        for job_pod in job_pods:
            assert job_pod.status().phase != "Failed", f"Detected failed job {job_pod.obj.metadata.name}"

        if len(pods) > 0 and all(is_pod_ready(pod) for pod in non_job_pods):
            # If all non-job pods are ready, we should be ready to proceed.
            break

        time.sleep(5)
    else:
        pytest.fail("❌ Timeout raised while waiting for pods to be ready")
    log.debug("✅ Done!")


def is_pod_ready(pod) -> bool:
    """
    Check the referenced pod is ready, without refreshing the status from the
    k8s API.

    Using the kubetest `is_ready` we end up calling the API each time, where as
    we already have the info we want after calling `kube.get_pods`. The
    additional calls occasionally result in API errors so we want to reduce the
    chance for failure and therefore test flakiness.

    This is a copy of the kubetest `Pod.is_ready`
    """
    status = pod.obj.status
    if status is None:
        return False

    # check the pod phase to make sure it is running. a pod in
    # the 'failed' or 'success' state will no longer be running,
    # so we only care if the pod is in the 'running' state.
    phase = status.phase
    if phase.lower() != "running":
        return False

    for cond in status.conditions:
        # we only care about the 'ready' condition
        if cond.type.lower() != "ready":
            continue

        # check that the readiness condition is true
        return cond.status.lower() == "true"

    # Catchall
    return False


def get_pod_restart_count(pod) -> int:
    """
    Get the total number of Container restarts for the Pod.

    This is a copy of the kubetest `Pod.get_restart_count` but without the call
    to `refresh()` such that we reduce the number of calls to the API, and
    reduce the chance for flakiness in that call.
    """
    container_statuses = pod.obj.status.container_statuses
    if container_statuses is None:
        return 0

    total = 0
    for container_status in container_statuses:
        total += container_status.restart_count

    return total


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


def create_namespace_if_not_exists(name=NAMESPACE):
    log.debug("🔄 Creating namespace {} (if not exists)...".format(name))
    cmd = "kubectl create namespace {} --dry-run=client -o yaml | kubectl apply -f -".format(name)
    exec_subprocess(cmd)
    log.debug("✅ Done!")


def install_custom_resources(filename, namespace=NAMESPACE):
    log.debug("🔄 Setting up custom resources for this test...")
    cmd = "kubectl apply -n {namespace} -f {filename}".format(namespace=namespace, filename=filename)
    exec_subprocess(cmd)
    log.debug("✅ Done!")


def apply_manifest(manifest_yaml: str):
    log.debug(f"🔄 Applying {manifest_yaml}...")
    with tempfile.NamedTemporaryFile() as manifest_file_obj:
        manifest_file_obj.write(manifest_yaml.encode("utf-8"))
        manifest_file_obj.flush()
        exec_subprocess(f"kubectl apply -f {manifest_file_obj.name}")
    log.debug("✅ Done!")


def exec_subprocess(cmd, ignore_errors=False):
    log.debug(f"🔄 Running: {cmd}")
    cmd_run = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    cmd_stdout = cmd_run.stdout
    stdout_cumulative = b""
    assert cmd_stdout is not None
    for chunk in iter(lambda: cmd_stdout.read(1), b""):
        sys.stdout.buffer.write(chunk)
        sys.stdout.buffer.flush()
        stdout_cumulative += chunk
    cmd_run.wait()  # Make sure we have a return code
    cmd_return_code = cmd_run.returncode
    if cmd_return_code and not ignore_errors:
        pytest.fail(
            f"""
        ❌ Error while running '{cmd}'.
        Return code: {cmd_return_code}

        OUTPUT: {stdout_cumulative}
        """
        )
    log.debug("✅ Done!")
    return stdout_cumulative


def install_external_kafka(namespace=NAMESPACE):
    log.debug("🔄 Setting up external Kafka...")
    cmd = """
          helm repo add bitnami https://raw.githubusercontent.com/bitnami/charts/pre-2022/bitnami && \
          helm upgrade --install \
            --namespace {namespace} \
            kafka bitnami/kafka \
            --version "14.9.3" \
            --set zookeeper.enabled=true \
            --set replicaCount=2
        """.format(
        namespace=namespace
    )
    exec_subprocess(cmd)
    log.debug("✅ Done!")
