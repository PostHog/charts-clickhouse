from helpers.utils import (
    VALUES_DISABLE_EVERYTHING,
    install_chart,
    is_posthog_healthy,
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
    kafka:
      enabled: true
    """,
)


def test_can_connect_from_web_pod(kube):
    install_chart(VALUES_ACCESS_CLICKHOUSE)
    wait_for_pods_to_be_ready(kube)

    is_posthog_healthy(kube)
