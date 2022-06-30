import logging
import time
from typing import Optional

import pytest

from helpers.utils import (
    NAMESPACE,
    cleanup_helm,
    cleanup_k8s,
    create_namespace_if_not_exists,
    exec_subprocess,
    helm_install,
    install_chart,
    install_custom_resources,
    merge_yaml,
    wait_for_pods_to_be_ready,
)

logging.basicConfig(level=logging.DEBUG)
log = logging.getLogger()

VALUES_WITH_BACKUP = """
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
"""


def test_backup(kube):
    cleanup_k8s([NAMESPACE, "posthog"])
    cleanup_helm([NAMESPACE, "posthog"])

    create_namespace_if_not_exists()
    install_custom_resources("./custom_k8s_resources/s3_minio.yaml")
    install_chart(VALUES_WITH_BACKUP)
    wait_for_pods_to_be_ready(kube)
    verify_backup(kube)


def verify_backup(kube):
    log.debug("🔄 Waiting when job pod is started...")
    start = time.time()
    timeout = 300
    while time.time() < start + timeout:
        pods = kube.get_pods(namespace=NAMESPACE, labels={"job": "clickhouse-backup"})
        if len(pods) > 0:
            for pod in pods.values():
                if pod.status().phase == "Running":
                    continue
            else:
                break
        else:
            time.sleep(30)
    # check backup pod status
    for pod in pods.values():
        if pod.status().phase == "Succeeded":
            log.debug(f"✅ Backup was created successfully for pod {pod.name}!")
            break
    else:
        pytest.fail("Backup is not succeeded for pod {pod.name}")

