# Defines some wrappers around the official kubernetes python client. There are
# a [couple of attempts](https://github.com/kubernetes-client/python/issues/225)
# to put some type hinting in place, but we only need a small subset and those
# attempts look stale.

from typing import List
from kubernetes import client, config
from kubernetes.client.models.v1_pod import V1Pod


def get_kube_client():
    config.load_kube_config()
    return client.CoreV1Api()


def get_pods(client: client.CoreV1Api, namespace: str = "posthog", label_selector: str = "app=posthog") -> List[V1Pod]:
    return client.list_namespaced_pod(namespace=namespace, label_selector=label_selector).items


def is_ready(pod: V1Pod) -> bool:
    assert pod.status
    return all(status.ready for status in pod.status.container_statuses)


def get_restart_count(pod: V1Pod):
    assert pod.status
    return sum(status.restart_count for status in pod.status.container_statuses or [])
