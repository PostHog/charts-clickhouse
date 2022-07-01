import pytest

from helpers.utils import NAMESPACE, install_chart, is_posthog_healthy, wait_for_pods_to_be_ready

VALUES_YAML = """
cloud: local

grafana:
    enabled: true
"""


def test_grafana(kube):
    install_chart(VALUES_YAML)
    wait_for_pods_to_be_ready(kube)

    is_posthog_healthy(kube)

    services = kube.get_services(namespace=NAMESPACE)
    service = services.get("posthog-grafana")
    assert service is not None
    assert service.is_ready()
