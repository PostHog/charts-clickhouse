import logging

import pytest

from utils import cleanup_k8s, install_chart, install_custom_kafka, is_posthog_healthy, wait_for_pods_to_be_ready

VALUES_YAML = """
cloud: local

kafka:
  enabled: false

externalKafka:
  brokers: "kafka0:9092"

# Disable zookeeper as we will use the built-in one from
# bitnami/kafka (see utils.install_custom_kafka)
zookeeper:
    enabled: false

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
    install_custom_kafka()
    install_chart(VALUES_YAML)
    wait_for_pods_to_be_ready(kube)


def test_helm_install(setup, kube):
    pass


def test_posthog_healthy(kube):
    is_posthog_healthy(kube)
