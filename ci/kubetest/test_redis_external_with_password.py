import base64
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
    -f ../../ci/values/kubetest/test_redis_external_with_password.yaml \
    --create-namespace \
    --namespace posthog \
    posthog ../../charts/posthog
"""


def test_redis_secret(kube):
    create_namespace_if_not_exists()
    install_custom_resources("./custom_k8s_resources/redis_external_with_password.yaml")
    helm_install(HELM_INSTALL_CMD)
    wait_for_pods_to_be_ready(kube)

    is_posthog_healthy(kube)

    secrets = kube.get_secrets(namespace="posthog", fields={"type": "Opaque"})

    default_redis_secret_name = "posthog-posthog-redis-external"
    assert default_redis_secret_name in secrets, "Unable to find the Redis secret (secret name: {})".format(
        default_redis_secret_name
    )

    expected_redis_secret_data = {"redis-password": base64.b64encode(b"staff-broken-apple-misplace-lamp").decode()}
    assert (
        secrets[default_redis_secret_name].obj.data == expected_redis_secret_data
    ), "Unexpected Redis secret data (secret name: {})".format(default_redis_secret_name)
