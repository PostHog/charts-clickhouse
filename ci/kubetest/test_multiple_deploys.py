from uuid import uuid4

from helpers.utils import exec_subprocess, wait_for_pods_to_be_ready


def helm_upgrade_posthog(namespace: str, release: str):
    exec_subprocess(
        f"""
        helm upgrade \
            --install \
            --set cloud=private \
            --set ingress.hostname={namespace} \
            --set clickhouse.namespace={namespace} \
            --timeout 30m \
            --create-namespace \
            --namespace {namespace} \
            --debug \
            {release} ../../charts/posthog
        """
    )


def test_multiple_installs_in_different_namespaces(kube):
    for namespace in [str(uuid4())] * 2:
        helm_upgrade_posthog(release="posthog", namespace=namespace)
        wait_for_pods_to_be_ready(kube, namespace=namespace)
