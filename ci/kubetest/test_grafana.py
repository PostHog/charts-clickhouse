import pytest

from utils import NAMESPACE, cleanup_k8s, install_chart, is_posthog_healthy, wait_for_pods_to_be_ready

VALUES_YAML = """
cloud: local

grafana:
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


def test_grafana(kube):
    services = kube.get_services(namespace=NAMESPACE)
    service = services.get("posthog-grafana")
    assert service is not None
    assert service.is_ready()
