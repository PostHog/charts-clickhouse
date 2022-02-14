import pytest

from utils import (
    cleanup_k8s,
    install_chart,
    is_posthog_healthy,
    is_prometheus_exporter_healthy,
    wait_for_pods_to_be_ready,
)

VALUES_YAML = """
cloud: local

prometheus-postgres-exporter:
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


def test_prometheus_postgres_exporter(kube):
    is_prometheus_exporter_healthy(kube, "prometheus-postgres-exporter", "pg_up 1")
