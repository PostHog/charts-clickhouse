import logging

from ..utils import NAMESPACE, exec_subprocess

log = logging.getLogger()


def is_prometheus_exporter_healthy(kube, exporter_name, expected_string):
    # TODO: we currently can't use the code commented below due to a possible bug
    # in `kubetest` as no pods gets returned by `get_pods()`.
    # Looks similar to https://github.com/vapor-ware/kubetest/pull/145 but I didn't
    # have time to investigate.
    #
    # deployments = kube.get_deployments(namespace="posthog")
    # deployment = deployments.get(deployment)
    # assert deployment is not None
    #
    # pods = deployment.get_pods()
    pods = kube.get_pods(namespace=NAMESPACE, labels={"app": exporter_name})
    assert len(pods) == 1, "{} deployment should have one pod".format(exporter_name)
    for pod in pods.values():
        containers = pod.get_containers()
        assert len(containers) == 1, "{} should have one container".format(exporter_name)
        resp = pod.http_proxy_get("/metrics")
        assert expected_string in resp.data


def install_external_statsd(namespace="posthog"):
    log.debug("🔄 Setting up external statsd...")
    cmd = """
          helm repo add prometheus-community https://prometheus-community.github.io/helm-charts && \
          helm upgrade --install \
            --namespace {namespace} \
            external prometheus-community/prometheus-statsd-exporter \
            --version "0.4.2"
        """.format(
        namespace=namespace
    )
    exec_subprocess(cmd)
    log.debug("✅ Done!")
