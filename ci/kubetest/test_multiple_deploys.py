from helpers.utils import cleanup_k8s, exec_subprocess, wait_for_pods_to_be_ready
from uuid import uuid4


def helm_upgrade_posthog(namespace: str, release: str):
    exec_subprocess(f"""
        helm upgrade \
            --install \
            --set cloud=private \
            --set ingress.hostname={namespace} \
            --set clickhouse.namespace={namespace} \
            --timeout 30m \
            --create-namespace \
            --namespace {namespace} \
            --debug \
            --wait \
            {release} ../../charts/posthog
        """
    )


def test_install_as_not_posthog(kube):
    namespace_1 = str(uuid4())
    helm_upgrade_posthog(release="posthog", namespace=namespace_1)
    namespace_2 = str(uuid4())
    helm_upgrade_posthog(release="posthog", namespace=namespace_2)
    wait_for_pods_to_be_ready(kube, namespace=namespace)
