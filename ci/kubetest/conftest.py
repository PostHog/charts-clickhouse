import pytest
from helpers.utils import exec_subprocess


@pytest.fixture
def kubeconfig() -> str:
    return '~/.kube/config'


@pytest.fixture(scope="session", autouse=True)
def delete_everything() -> str:
    """
    Make sure we reset k8s before we start tests, ensuring we remove all things
    not caught by `all`
    """
    exec_subprocess('kubectl delete "$(kubectl api-resources --namespaced=true --verbs=delete -o name | tr "\n" "," | sed -e \'s/,$//\')" --all')
