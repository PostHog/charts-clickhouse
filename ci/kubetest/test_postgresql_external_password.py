import pytest

from helpers.utils import (
    create_namespace_if_not_exists,
    exec_subprocess,
    install_chart,
    install_custom_resources,
    wait_for_pods_to_be_ready,
)

VALUES_EXTERNAL_POSTGRESQL_WITH_PASSWORD = """
postgresql:
  enabled: false

externalPostgresql:
  postgresqlHost: "postgresql-external.posthog.svc.cluster.local"
  postgresqlDatabase: kubetest_db
  postgresqlUsername: kubetest_user
  postgresqlPassword: kubetest_password
"""


@pytest.mark.parametrize(
    "values,resources_to_install",
    [
        pytest.param(
            VALUES_EXTERNAL_POSTGRESQL_WITH_PASSWORD,
            ["./custom_k8s_resources/postgresql_external.yaml"],
            id="EXTERNAL_POSTGRESQL_WITH_PASSWORD",
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
