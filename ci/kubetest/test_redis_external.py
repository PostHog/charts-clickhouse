import logging

import pytest

from helpers.utils import (
    create_namespace_if_not_exists,
    helm_install,
    install_custom_resources,
    is_posthog_healthy,
    wait_for_pods_to_be_ready,
)

log = logging.getLogger()

HELM_INSTALL_CMD = """
helm upgrade \
    --install \
    --timeout 30m \
    -f ../../ci/values/kubetest/test_redis_external.yaml \
    --create-namespace \
    --namespace posthog \
    posthog ../../charts/posthog
"""


@pytest.fixture
def setup(kube):
    create_namespace_if_not_exists()
    install_custom_resources("./custom_k8s_resources/redis_external.yaml")
    helm_install(HELM_INSTALL_CMD)
    wait_for_pods_to_be_ready(kube)


def test_helm_install(setup, kube):
    pass


def test_posthog_healthy(kube):
    is_posthog_healthy(kube)


def test_redis_secret(kube):
    secrets = kube.get_secrets(namespace="posthog", fields={"type": "Opaque"})

    assert "redis" not in secrets.keys(), "Redis secret found"
