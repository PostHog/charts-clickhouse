import pytest

from utils import (
    NAMESPACE,
    cleanup_k8s,
    exec_subprocess,
    install_chart,
    install_custom_resources,
    merge_yaml,
    wait_for_pods_to_be_ready,
)

VALUES_INTERNAL_POSTGRESQL_DEFAULTS = """
cloud: "local"
"""

# :TODO: postgresqlUsername and nameOverride don't work as expected - debug and fix!
VALUES_INTERNAL_POSTGRESQL_OVERRIDES = """
cloud: "local"

postgresql:
  postgresqlDatabase: kubetest_db
  postgresqlPassword: kubetest_password
"""



@pytest.mark.parametrize(
    "values,resources_to_install",
    [
        pytest.param(VALUES_INTERNAL_POSTGRESQL_DEFAULTS, [], id="INTERNAL_POSTGRESQL_DEFAULTS"),
        pytest.param(VALUES_INTERNAL_POSTGRESQL_OVERRIDES, [], id="INTERNAL_POSTGRESQL_OVERRIDES"),
    ]
)
def test_can_connect_from_web_pod(values, resources_to_install, kube):
    cleanup_k8s([NAMESPACE])

    install_chart(values)
    wait_for_pods_to_be_ready(kube)

    verify_can_connect_to_postgresql(kube)

def verify_can_connect_to_postgresql(kube):
    pods = kube.get_pods(namespace=NAMESPACE, labels={"role": "web"})
    pod = list(pods.values())[0]
    # _preflight endpoint returns the status of most of our services
    preflight_response = pod.http_proxy_get("/_preflight").json()

    assert preflight_response['db'], f"Web pod couldn't connect to postgresql, preflight response: {preflight_response}"

