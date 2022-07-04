import logging
import time

import pytest

from helpers.utils import (
    NAMESPACE,
    VALUES_DISABLE_EVERYTHING,
    create_namespace_if_not_exists,
    install_chart,
    install_custom_resources,
    merge_yaml,
    wait_for_pods_to_be_ready,
)

log = logging.getLogger()

VALUES_CLICKHOUSE_WITH_BACKUP = merge_yaml(
    VALUES_DISABLE_EVERYTHING,
    """
    zookeeper:
      enabled: true

    clickhouse:
      enabled: true
      backup:
        enabled: true
        backup_schedule: "*/2 * * * *"
        env:
        - name: LOG_LEVEL
          value: "debug"
        - name: ALLOW_EMPTY_BACKUPS
          value: "true"
        - name: API_LISTEN
          value: "0.0.0.0:7171"
        # INSERT INTO system.backup_actions to execute backup
        - name: API_CREATE_INTEGRATION_TABLES
          value: "true"
        - name: BACKUPS_TO_KEEP_REMOTE
          value: "3"
        - name: REMOTE_STORAGE
          value: "s3"
        - name: S3_ACL
          value: "private"
        - name: S3_ENDPOINT
          value: http://s3-backup-minio:9000
        - name: S3_BUCKET
          value: backups
        - name: S3_PATH
          value: clickhouse
        - name: S3_ACCESS_KEY
          value: backup-access-key
        - name: S3_SECRET_KEY
          value: backup-secret-key
        - name: S3_FORCE_PATH_STYLE
          value: "true"
        - name: S3_DISABLE_SSL
          value: "true"
        - name: S3_DEBUG
          value: "true"
    """,
)


def test_backup(kube):
    create_namespace_if_not_exists()
    install_custom_resources("./custom_k8s_resources/s3_minio.yaml")
    install_chart(VALUES_CLICKHOUSE_WITH_BACKUP)
    wait_for_pods_to_be_ready(kube)

    assert is_clickhouse_backup_cron_working(kube) is True


def is_clickhouse_backup_cron_working(kube) -> bool:
    deadline = time.time() + 500
    while time.time() < deadline:
        pods = kube.get_pods(namespace=NAMESPACE, labels={"job": "clickhouse-backup"})

        if len(pods) < 1:
            continue  # loop till clickhouse-backup pods are available

        for pod in pods.values():
            pod_phase = pod.status().phase
            log.debug(f"{pod.name} is in status {pod_phase}")
            if pod_phase == "Succeeded":
                return True
            if pod_phase == "Failed":
                return False
            time.sleep(1)
    else:
        log.debug(f"Timed out while waiting for clickhouse-backup to succeed")
        return False
