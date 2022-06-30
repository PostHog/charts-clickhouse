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
                --timeout 30m \
                --create-namespace \
                --namespace {namespace} \
                posthog ../../charts/posthog \
                --wait-for-jobs \
                --wait
        """
        )
    log.debug("✅ Done!")


def kubectl_exec(pod, command):
    log.debug(f"🔄 Executing command '{command}' in pod {pod}")
    output = exec_subprocess(f"kubectl exec {pod} --namespace {NAMESPACE} -- {command}")
    log.debug("✅ Done!")

    return output


def wait_for_pods_to_be_ready(kube, labels={}, expected_count=None, namespace=NAMESPACE):
    log.debug("🔄 Waiting for all pods to be ready...")
    time.sleep(30)
    start = time.time()
    timeout = 300
    while time.time() < start + timeout:
        pods = kube.get_pods(namespace=namespace, labels=labels)

        if expected_count is not None and len(pods) < expected_count:
            continue

        for pod in pods.values():
            if not pod.is_ready():
                continue
        break
    else:
        pytest.fail("❌ Timeout raised while waiting for pods to be ready")
    log.debug("✅ Done!")


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
          helm repo add bitnami https://charts.bitnami.com/bitnami && \
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
