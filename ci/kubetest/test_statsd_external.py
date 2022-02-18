import pytest

from utils import cleanup_k8s, install_chart, is_posthog_healthy, wait_for_pods_to_be_ready
from helpers.metrics import install_external_statsd

VALUES_YAML = """
cloud: local

externalStatsd:
  host: "external-prometheus-statsd-exporter"
  port: "9125"
"""


@pytest.fixture
def setup(kube):
    cleanup_k8s()
    install_external_statsd()
    install_chart(VALUES_YAML)
    wait_for_pods_to_be_ready(kube)


def test_helm_install(setup, kube):
    pass


def test_posthog_healthy(kube):
    is_posthog_healthy(kube)
