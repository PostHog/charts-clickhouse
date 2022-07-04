import pytest

from helpers.utils import (
    create_namespace_if_not_exists,
    exec_subprocess,
    install_chart,
    install_custom_resources,
    wait_for_pods_to_be_ready,
)

VALUES_INTERNAL_POSTGRESQL_WITH_EXISTING_SECRET = """
postgresql:
  existingSecret: postgresql-existing-secret
"""


@pytest.mark.parametrize(
    "values,resources_to_install",
    [
        pytest.param(
            VALUES_INTERNAL_POSTGRESQL_WITH_EXISTING_SECRET,
            ["./custom_k8s_resources/postgresql_existing_secret.yaml"],
            id="INTERNAL_POSTGRESQL_WITH_EXISTING_SECRET",
        ),
    ],
)
def test_can_connect_from_web_pod(values, resources_to_install, kube):
    for resource in resources_to_install:
        exec_subprocess("kubectl delete pvc --all --all-namespaces", ignore_errors=True)
        create_namespace_if_not_exists()
        install_custom_resources(resource)

    install_chart(values)
    wait_for_pods_to_be_ready(kube)
