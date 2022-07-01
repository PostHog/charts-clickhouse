import pytest

from helpers.metrics import is_prometheus_exporter_healthy
from helpers.utils import install_chart, is_posthog_healthy, wait_for_pods_to_be_ready

VALUES_YAML = """
cloud: local

prometheus-kafka-exporter:
    enabled: true
"""


def test_prometheus_kafka_exporter(kube):
    install_chart(VALUES_YAML)
    wait_for_pods_to_be_ready(kube)
    is_posthog_healthy(kube)

    is_prometheus_exporter_healthy(kube, "prometheus-kafka-exporter", "kafka_brokers 1")
