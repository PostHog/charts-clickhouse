import pytest

from helpers.utils import (
    NAMESPACE,
    VALUES_DISABLE_EVERYTHING,
    cleanup_helm,
    cleanup_k8s,
    exec_subprocess,
    install_chart,
    install_custom_resources,
    merge_yaml,
    wait_for_pods_to_be_ready,
)

VALUES_ACCESS_CLICKHOUSE = merge_yaml(
    VALUES_DISABLE_EVERYTHING,
    """
    clickhouse:
      enabled: true
    zookeeper:
      enabled: true
    web:
      enabled: true
    migrate:
      enabled: true
    postgresql:
      enabled: true
    redis:
      enabled: true
    pgbouncer:
      enabled: true
    """,
)

VALUES_EXTERNAL_CLICKHOUSE = merge_yaml(
    VALUES_DISABLE_EVERYTHING,
    """
    clickhouse:
      enabled: true
      cluster: kubetest
      database: kubetest_db
      user: kubeuser
      password: kubetestpw

    zookeeper:
      enabled: true
    """,
)

VALUES_ACCESS_EXTERNAL_CLICKHOUSE_VIA_PASSWORD = merge_yaml(
    VALUES_DISABLE_EVERYTHING,
    """
    web:
      enabled: true
    migrate:
      enabled: true
    postgresql:
      enabled: true
    redis:
      enabled: true
    pgbouncer:
      enabled: true

    externalClickhouse:
      host: "clickhouse-posthog.clickhouse.svc.cluster.local"
      cluster: kubetest
      database: kubetest_db
      user: kubeuser
      password: kubetestpw
    """,
)

VALUES_ACCESS_EXTERNAL_CLICKHOUSE_VIA_SECRET = merge_yaml(
    VALUES_ACCESS_EXTERNAL_CLICKHOUSE_VIA_PASSWORD,
    """
    externalClickhouse:
      host: "clickhouse-posthog.clickhouse.svc.cluster.local"
      cluster: kubetest
      database: kubetest_db
      user: kubeuser
      existingSecret: clickhouse-existing-secret
      existingSecretPasswordKey: clickhouse-password
    """,
)


def test_can_connect_from_web_pod(kube):
    install_chart(VALUES_ACCESS_CLICKHOUSE)
    wait_for_pods_to_be_ready(kube)


def test_can_connect_external_clickhouse_via_password(kube):
    setup_external_clickhouse()
    install_chart(VALUES_ACCESS_EXTERNAL_CLICKHOUSE_VIA_PASSWORD)
    wait_for_pods_to_be_ready(kube)


def test_can_connect_external_clickhouse_via_secret(kube):
    install_custom_resources("./custom_k8s_resources/clickhouse_external_secret.yaml")
    setup_external_clickhouse()
    install_chart(VALUES_ACCESS_EXTERNAL_CLICKHOUSE_VIA_SECRET)
    wait_for_pods_to_be_ready(kube)


def setup_external_clickhouse():
    # :TRICKY: We can't use a single docker image since posthog relies on clickhouse being installed in a cluster
    install_chart(VALUES_EXTERNAL_CLICKHOUSE, namespace="clickhouse")


@pytest.fixture(autouse=True)
def before_each_cleanup():
    cleanup_k8s([NAMESPACE, "clickhouse"])
    cleanup_helm([NAMESPACE, "clickhouse"])
