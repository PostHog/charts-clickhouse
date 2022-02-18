import pytest

from helpers.metrics import is_prometheus_exporter_healthy
from utils import cleanup_k8s, install_chart, is_posthog_healthy, wait_for_pods_to_be_ready

VALUES_YAML = """
cloud: local

prometheus-kafka-exporter:
    enabled: true
"""


@pytest.fixture
def setup(kube):
    cleanup_k8s()
    install_chart(VALUES_YAML)
    wait_for_pods_to_be_ready(kube)


def test_helm_install(setup, kube):
    pass


def test_posthog_healthy(kube):
    is_posthog_healthy(kube)


def test_prometheus_kafka_exporter(kube):
    is_prometheus_exporter_healthy(kube, "prometheus-kafka-exporter", "kafka_brokers 1")
