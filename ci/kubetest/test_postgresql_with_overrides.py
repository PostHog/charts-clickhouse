import pytest

from helpers.utils import (
    create_namespace_if_not_exists,
    exec_subprocess,
    install_chart,
    install_custom_resources,
    wait_for_pods_to_be_ready,
)

VALUES_INTERNAL_POSTGRESQL_OVERRIDES = """
postgresql:
  nameOverride: kubetest-pg
  postgresqlDatabase: kubetest_db
  postgresqlPassword: kubetest_password
"""


@pytest.mark.parametrize(
    "values,resources_to_install",
    [
        pytest.param(VALUES_INTERNAL_POSTGRESQL_OVERRIDES, [], id="INTERNAL_POSTGRESQL_OVERRIDES"),
    ],
)
def test_can_connect_from_web_pod(values, resources_to_install, kube):
    for resource in resources_to_install:
        exec_subprocess("kubectl delete pvc --all --all-namespaces", ignore_errors=True)
        create_namespace_if_not_exists()
        install_custom_resources(resource)

    install_chart(values)
    wait_for_pods_to_be_ready(kube)
