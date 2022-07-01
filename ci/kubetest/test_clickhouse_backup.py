import logging
import time
from typing import Optional

import pytest

from helpers.clickhouse import get_clickhouse_cluster_service_spec
from helpers.utils import (
    NAMESPACE,
    VALUES_DISABLE_EVERYTHING,
    create_namespace_if_not_exists,
    exec_subprocess,
    helm_install,
    install_chart,
    install_custom_resources,
    merge_yaml,
    wait_for_pods_to_be_ready,
)

log = logging.getLogger()

VALUES_CLICKHOUSE = merge_yaml(
    VALUES_DISABLE_EVERYTHING,
    """
    clickhouse:
      enabled: true
    zookeeper:
      enabled: true
    """,
)

VALUES_CLICKHOUSE_WITH_BACKUP = merge_yaml(
    VALUES_CLICKHOUSE,
    """
    clickhouse:
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
          value: clickhouse
        - name: S3_PATH
          value: backup
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


# def test_backup(kube):
#     create_namespace_if_not_exists()
#     install_custom_resources("./custom_k8s_resources/s3_minio.yaml")
#     install_chart(VALUES_CLICKHOUSE)  # start installing the stack
#     wait_for_pods_to_be_ready(kube)

#     install_chart(VALUES_CLICKHOUSE_WITH_BACKUP)  # install the backup in a second
#     # run as there's a race condition between clickhouse pods being available and
#     # the backup cron execution
#     wait_for_pods_to_be_ready(kube)
#     verify_backup(kube)


# def verify_backup(kube):
#     log.debug("🔄 Waiting when job pod is started...")
#     start = time.time()
#     timeout = 300
#     while time.time() < start + timeout:
#         pods = kube.get_pods(namespace=NAMESPACE, labels={"job": "clickhouse-backup"})
#         if len(pods) > 0:
#             for pod in pods.values():
#                 if pod.status().phase == "Running":
#                     continue
#             else:
#                 break
#         else:
#             time.sleep(30)
#     # check backup pod status
#     for pod in pods.values():
#         if pod.status().phase == "Succeeded":
#             log.debug(f"✅ Backup was created successfully for pod {pod.name}!")
#             break
#     else:
#         pytest.fail("Backup is not succeeded for pod {pod.name}")
