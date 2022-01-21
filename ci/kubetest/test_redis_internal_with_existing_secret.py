import base64
import logging
import subprocess
from dataclasses import Field, fields

import pytest

from utils import (
    cleanup_k8s,
    create_namespace_if_not_exists,
    helm_install,
    install_custom_resources,
    is_posthog_healthy,
    wait_for_pods_to_be_ready,
)

logging.basicConfig(level=logging.DEBUG)
log = logging.getLogger()

HELM_INSTALL_CMD = """
helm upgrade \
    --install \
    --timeout 30m \
    -f ../../ci/values/kubetest/test_redis_internal_with_existing_secret.yaml \
    --create-namespace \
    --namespace posthog \
    posthog ../../charts/posthog \
    --wait-for-jobs \
    --wait
"""


@pytest.fixture
def setup(kube):
    # cleanup_k8s()
    create_namespace_if_not_exists()
    # install_custom_resources("./custom_k8s_resources/redis_internal_with_existing_secret.yaml")
    # helm_install(HELM_INSTALL_CMD)
    # wait_for_pods_to_be_ready(kube)


def test_helm_install(setup, kube):
    pass


def test_posthog_healthy(kube):
    is_posthog_healthy(kube)


def test_redis_secret(kube):
    secrets = kube.get_secrets(namespace="posthog", fields={"type": "Opaque"})

    default_redis_secret_name = "posthog-posthog-redis-external"
    assert default_redis_secret_name not in secrets.keys(), "Default Redis secret found (secret name: {})".format(
        default_redis_secret_name
    )

    expected_redis_secret_name = "redis-existing-secret"
    assert expected_redis_secret_name in secrets.keys(), "Expected Redis secret not found (secret name: {})".format(
        expected_redis_secret_name
    )
