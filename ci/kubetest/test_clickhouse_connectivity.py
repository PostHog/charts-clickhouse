import pytest

from utils import (
    NAMESPACE,
    VALUES_DISABLE_EVERYTHING,
    cleanup_k8s,
    exec_subprocess,
    install_chart,
    install_custom_resources,
    wait_for_pods_to_be_ready,
)

VALUES_ACCESS_CLICKHOUSE = {
    **VALUES_DISABLE_EVERYTHING,
    "clickhouse": {"enabled": True},
    "zookeeper": {"enabled": True},
    "web": {"enabled": True},
    "migrate": {"enabled": True},
    "postgresql": {"enabled": True},
    "redis": {"enabled": True},
    "pgbouncer": {"enabled": True},
}

VALUES_EXTERNAL_CLICKHOUSE = {
    **VALUES_DISABLE_EVERYTHING,
    "clickhouse": {
        "enabled": True,
        "cluster": "kubetest",
        "database": "kubetest_db",
        "user": "admin",  # :TODO: Chart lies about allowing to specify a non-admin user.
        "password": "kubetestpw",
    },
    "zookeeper": {"enabled": True},
}

VALUES_ACCESS_EXTERNAL_CLICKHOUSE_VIA_PASSWORD = {
    **VALUES_DISABLE_EVERYTHING,
    "web": {"enabled": True},
    "migrate": {"enabled": True},
    "postgresql": {"enabled": True},
    "redis": {"enabled": True},
    "pgbouncer": {"enabled": True},
    "externalClickhouse": {
        "host": "clickhouse-posthog.clickhouse.svc.cluster.local",
        "cluster": "kubetest",
        "database": "kubetest_db",
        "user": "admin",
        "password": "kubetestpw",
        # "existingSecret": "clickhouse-existing-secret",
        # "existingSecretPasswordKey": "clickhouse-password"
    },
}

VALUES_ACCESS_EXTERNAL_CLICKHOUSE_VIA_SECRET = {
    **VALUES_ACCESS_EXTERNAL_CLICKHOUSE_VIA_PASSWORD,
    "externalClickhouse": {
        "host": "clickhouse-posthog.clickhouse.svc.cluster.local",
        "cluster": "kubetest",
        "database": "kubetest_db",
        "user": "admin",
        "existingSecret": "clickhouse-existing-secret",
        "existingSecretPasswordKey": "clickhouse-password",
    },
}


def test_can_connect_from_web_pod(kube):
    install_chart(VALUES_ACCESS_CLICKHOUSE)
    wait_for_pods_to_be_ready(kube)

    verify_can_connect_to_clickhouse(kube)


def test_can_connect_external_clickhouse_via_password(kube):
    setup_external_clickhouse()
    install_chart(VALUES_ACCESS_EXTERNAL_CLICKHOUSE_VIA_PASSWORD)
    wait_for_pods_to_be_ready(kube)

    verify_can_connect_to_clickhouse(kube)


def test_can_connect_external_clickhouse_via_secret(kube):
    install_custom_resources("./custom_k8s_resources/clickhouse_external_secret.yaml")
    setup_external_clickhouse()
    install_chart(VALUES_ACCESS_EXTERNAL_CLICKHOUSE_VIA_SECRET)
    wait_for_pods_to_be_ready(kube)

    verify_can_connect_to_clickhouse(kube)


def setup_external_clickhouse():
    # :TRICKY: We can't use a single docker image since posthog relies on clickhouse being installed in a cluster
    install_chart(VALUES_EXTERNAL_CLICKHOUSE, namespace="clickhouse")


def verify_can_connect_to_clickhouse(kube):
    "Checks whether clickhouse is connectable from the web pod"
    pods = kube.get_pods(namespace=NAMESPACE, labels={"role": "web"})
    pod = list(pods.values())[0]

    command = " ".join(
        [
            f"kubectl exec --stdin --tty {pod.name} -n posthog",
            "--",
            "python manage.py shell_plus -c",
            "\"print('connection check success', sync_execute('select count() from events')[0][0])\"",
        ]
    )

    # This will exit 0 if clickhouse is not connectable
    exec_subprocess(command)


@pytest.fixture(autouse=True)
def before_each_cleanup():
    cleanup_k8s(["default", NAMESPACE, "clickhouse"])
