import pytest

from utils import (
    cleanup_k8s,
    create_namespace_if_not_exists,
    install_chart,
    install_external_kafka,
    is_posthog_healthy,
    wait_for_pods_to_be_ready,
)

VALUES_YAML = """
cloud: local

kafka:
  enabled: false

externalKafka:
  brokers: "kafka0:9092"

#
# For the purpose of this test, let's disable service persistence
#
clickhouse:
  persistence:
    enabled: false
kafka:
  persistence:
    enabled: false
pgbouncer:
  persistence:
    enabled: false
postgresql:
  persistence:
    enabled: false
redis:
  master:
    persistence:
      enabled: false
zookeeper:
  persistence:
    enabled: false
"""


@pytest.fixture
def setup(kube):
    cleanup_k8s()
    create_namespace_if_not_exists()
    install_external_kafka()
    install_chart(VALUES_YAML)
    wait_for_pods_to_be_ready(kube)


def test_helm_install(setup, kube):
    pass


def test_posthog_healthy(kube):
    is_posthog_healthy(kube)
