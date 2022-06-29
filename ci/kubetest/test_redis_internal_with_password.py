import base64
import logging

import pytest

from helpers.utils import cleanup_k8s, helm_install, is_posthog_healthy, wait_for_pods_to_be_ready

logging.basicConfig(level=logging.DEBUG)
log = logging.getLogger()

HELM_INSTALL_CMD = """
helm upgrade \
    --install \
    -f ../../ci/values/kubetest/test_redis_internal_with_password.yaml \
    --create-namespace \
    --namespace posthog \
    posthog ../../charts/posthog
"""


@pytest.fixture
def setup(kube):
    cleanup_k8s()
    helm_install(HELM_INSTALL_CMD)
    wait_for_pods_to_be_ready(kube)


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

    expected_redis_secret_name = "posthog-posthog-redis"
    assert expected_redis_secret_name in secrets, "Unable to find the Redis secret (secret name: {})".format(
        expected_redis_secret_name
    )
    expected_redis_secret_data = {"redis-password": base64.b64encode(b"staff-broken-apple-misplace-lamp").decode()}
    assert (
        secrets[expected_redis_secret_name].obj.data == expected_redis_secret_data
    ), "Unexpected Redis secret data (secret name: {})".format(expected_redis_secret_name)
