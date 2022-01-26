import json

import pytest

from utils import cleanup_k8s, install_chart, kubectl_exec, wait_for_pods_to_be_ready

VALUES_YAML = """
cloud: local

clickhouse:
  profiles:
    default/max_execution_time: 90
    default/max_memory_usage: 20000000000

#
# For the purpose of this test, let's disable everything else
#

# PostHog
web:
  enabled: false
migrate:
  enabled: false
events:
  enabled: false
worker:
  enabled: false
plugins:
  enabled: false

# Services
postgresql:
  enabled: false
redis:
  enabled: false
kafka:
  enabled: false
ingress:
  enabled: false
pgbouncer:
  enabled: false
"""


@pytest.fixture
def setup(kube):
    cleanup_k8s()
    install_chart(VALUES_YAML)
    wait_for_pods_to_be_ready(kube)


def test_custom_clickhouse_settings_profile(setup, kube):
    command = f"clickhouse-client -q \"SELECT name, value FROM system.settings WHERE name IN ('max_execution_time', 'max_memory_usage') ORDER BY name FORMAT JSON\""
    result = kubectl_exec("chi-posthog-posthog-0-0-0", command)
    settings = json.loads(result)["data"]

    assert settings == [
        {"name": "max_execution_time", "value": "90"},
        {"name": "max_memory_usage", "value": "20000000000"},
    ]
