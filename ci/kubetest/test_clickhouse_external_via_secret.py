from helpers.utils import (
    VALUES_DISABLE_EVERYTHING,
    create_namespace_if_not_exists,
    install_chart,
    install_custom_resources,
    is_posthog_healthy,
    merge_yaml,
    wait_for_pods_to_be_ready,
)

VALUES_EXTERNAL_CLICKHOUSE = merge_yaml(
    VALUES_DISABLE_EVERYTHING,
    """
    clickhouse:
      enabled: true
      cluster: name-with-dash
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
    kafka:
      enabled: true
    zookeeper:
      enabled: true

    clickhouse:
      enabled: false

    externalClickhouse:
      host: "clickhouse-posthog.clickhouse.svc.cluster.local"
      cluster: name-with-dash
      database: kubetest_db
      user: kubeuser
      password: kubetestpw
    """,
)

VALUES_ACCESS_EXTERNAL_CLICKHOUSE_VIA_SECRET = merge_yaml(
    VALUES_ACCESS_EXTERNAL_CLICKHOUSE_VIA_PASSWORD,
    """
    clickhouse:
      enabled: false

    externalClickhouse:
      host: "clickhouse-posthog.clickhouse.svc.cluster.local"
      cluster: name-with-dash
      database: kubetest_db
      user: kubeuser
      existingSecret: clickhouse-existing-secret
      existingSecretPasswordKey: clickhouse-password
    """,
)


def test_can_connect_external_clickhouse_via_secret(kube):
    create_namespace_if_not_exists()
    install_custom_resources("./custom_k8s_resources/clickhouse_external_secret.yaml")
    install_chart(VALUES_EXTERNAL_CLICKHOUSE, namespace="clickhouse")  # setup external ClickHouse
    install_chart(VALUES_ACCESS_EXTERNAL_CLICKHOUSE_VIA_SECRET)
    wait_for_pods_to_be_ready(kube)

    is_posthog_healthy(kube)
