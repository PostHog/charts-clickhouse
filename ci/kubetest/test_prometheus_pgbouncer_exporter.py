import pytest

from helpers.metrics import is_prometheus_exporter_healthy
from helpers.utils import install_chart, is_posthog_healthy, wait_for_pods_to_be_ready

VALUES_YAML = """
cloud: local

ingress:
    enabled: false

pgbouncer:
    exporter:
        enabled: true
"""


def test_prometheus_pgbouncer_exporter(kube):
    install_chart(VALUES_YAML)
    wait_for_pods_to_be_ready(kube)

    is_posthog_healthy(kube)
