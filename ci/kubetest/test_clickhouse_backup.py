import pytest
import time

from helpers.clickhouse import get_clickhouse_cluster_service_spec
from helpers.utils import cleanup_k8s, cleanup_helm, helm_install, wait_for_pods_to_be_ready, install_chart
from helpers.utils import (
    NAMESPACE,
    cleanup_helm,
    cleanup_k8s,
    exec_subprocess,
    install_chart,
    install_custom_resources,
    merge_yaml,
    wait_for_pods_to_be_ready,
)



from typing import Optional

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
    # change it for production S3
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
    # remove it for production S3
    - name: S3_DISTABLE_SSL
      value: "true"
    - name: S3_DEBUG
      value: "true"
"""


def test_backup(kube):
    install_custom_resources("./custom_k8s_resources/s3_minio.yaml")
    install_chart(VALUES_WITH_BACKUP)
    wait_for_pods_to_be_ready(kube)
    verify_backup(kube)


def verify_backup(kube):
    "Check backup creation"
    wait_timeout = 300
    start = time.time()
    while True:
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
        print(f"Backup was created successfully for pod {pod.name}")
        break
    else:
      pytest.fail("Backup is not succeeded for pod {pod.name}")

@pytest.fixture(autouse=True)
def before_each_cleanup():
    cleanup_k8s([NAMESPACE, "posthog"])
    cleanup_helm([NAMESPACE, "posthog"])