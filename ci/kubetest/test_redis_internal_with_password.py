import base64
import logging

import pytest

from helpers.utils import helm_install, is_posthog_healthy, wait_for_pods_to_be_ready

log = logging.getLogger()

HELM_INSTALL_CMD = """
helm upgrade \
    --install \
    --timeout 30m \
    -f ../../ci/values/kubetest/test_redis_internal_with_password.yaml \
    --create-namespace \
    --namespace posthog \
    posthog ../../charts/posthog \
    --wait-for-jobs \
    --wait
"""


def test_redis_secret(kube):

    helm_install(HELM_INSTALL_CMD)
    wait_for_pods_to_be_ready(kube)

    is_posthog_healthy(kube)

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
