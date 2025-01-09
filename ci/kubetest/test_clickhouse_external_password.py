from helpers.utils import (
    VALUES_DISABLE_EVERYTHING,
    install_chart,
    is_posthog_healthy,
    merge_yaml,
    wait_for_pods_to_be_ready,
)

VALUES_EXTERNAL_CLICKHOUSE = merge_yaml(
    VALUES_DISABLE_EVERYTHING,
    """
    clickhouse:
      enabled: true
      cluster: namewithoutdash
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
      cluster: namewithoutdash
      database: kubetest_db
      user: kubeuser
      password: kubetestpw
    """,
)


def test_can_connect_external_clickhouse_via_password(kube):
    install_chart(VALUES_EXTERNAL_CLICKHOUSE, namespace="clickhouse")  # setup external ClickHouse
    install_chart(VALUES_ACCESS_EXTERNAL_CLICKHOUSE_VIA_PASSWORD)
    wait_for_pods_to_be_ready(kube)

    is_posthog_healthy(kube)
