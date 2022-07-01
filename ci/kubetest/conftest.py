import logging

import pytest

from helpers.utils import exec_subprocess

log = logging.getLogger()


@pytest.fixture
def kubeconfig() -> str:
    return "~/.kube/config"


@pytest.fixture(scope="module", autouse=True)
def reset() -> None:
    reset_k8s()
    reset_helm()


def reset_k8s() -> None:
    """
    Make sure we reset the Kubernetes cluster before we start tests, ensuring
    we remove all things not caught by `all`
    """
    log.info("🔄 Resetting Kubernetes...")

    #
    # Delete all the namespaced resources
    #
    log.debug("Deleting all the namespaced resources...")
    namespaces_raw = exec_subprocess(
        'kubectl get namespaces --no-headers -o custom-columns=":metadata.name" | grep -v "kube-" | grep -v "default" | grep -v "kubetest-" | tr "\n" ","'
    )
    namespaces = namespaces_raw.decode().split(",")[:-1]
    for namespace in namespaces:
        # We can't successfully delete a namespace if we have a chi lying around
        # in it as it will make it stuck on a the remaining finalizer:
        # finalizer.clickhouseinstallation.altinity.com
        patch = '{"metadata":{"finalizers":null}}'
        exec_subprocess(
            f"kubectl patch chi posthog -n {namespace} -p '{patch}' --type=merge",
            ignore_errors=True,
        )
        exec_subprocess(
            f"kubectl delete chi posthog -n {namespace} --ignore-not-found",
            ignore_errors=True,
        )
        exec_subprocess(f"kubectl delete namespace {namespace}")
    log.debug("Done!")

    #
    # Delete all the non-namespaced resources
    #
    # In the case of our chart those are limited to:
    # - clusterrole
    # - clusterrolebinding
    # - clickhouse-operator CDRs
    #
    # TODO: find a way to better automate this. The problem of non-namespaced resources is that it is
    # difficult to understand if they are installed by the chart or they are part of the k8s control plane.
    #
    log.debug("Deleting all the non-namespaced resources...")
    clusterrolesbinding_raw = exec_subprocess(
        'kubectl get clusterrolebinding --no-headers -o custom-columns=":metadata.name" | grep "clickhouse-" | tr "\n" ","'
    )
    clusterrolesbinding = clusterrolesbinding_raw.decode().split(",")[:-1]
    for clusterrolebinding in clusterrolesbinding:
        exec_subprocess(f"kubectl delete clusterrolebinding {clusterrolebinding}")

    clusterroles_raw = exec_subprocess(
        'kubectl get clusterrole --no-headers -o custom-columns=":metadata.name" | grep "clickhouse-" | tr "\n" ","'
    )
    clusterroles = clusterroles_raw.decode().split(",")[:-1]
    for clusterrole in clusterroles:
        exec_subprocess(f"kubectl delete clusterrole {clusterrole}")
    log.debug("Done!")

    log.info("✅ Done!")


def reset_helm() -> None:
    """
    Make sure we reset the Helm release history before we start tests
    """
    log.info("🔄 Resetting Helm...")
    exec_subprocess("helm list --short | xargs -L1 helm delete", ignore_errors=True)
    log.info("✅ Done!")


class NoParsingFilter(logging.Filter):
    def filter(self, record):
        return "falling back to preferred version" not in record.getMessage()


@pytest.fixture(autouse=True)
def hide_kubetest_logging():
    """
    Kubetest appears to
    """
    logger = logging.getLogger("kubetest")
    logger.addFilter(NoParsingFilter())
