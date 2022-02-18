def get_clickhouse_statefulset_spec(kube):
    statefulsets = kube.get_statefulsets(
        namespace="posthog",
        labels={"clickhouse.altinity.com/namespace": "posthog"},
    )
    statefulset = next(iter(statefulsets.values()))
    return statefulset.obj.spec


def get_clickhouse_cluster_service_spec(kube):
    services = kube.get_services(
        namespace="posthog",
        labels={
            "clickhouse.altinity.com/namespace": "posthog",
            "clickhouse.altinity.com/Service": "cluster",
        },
    )
    service = next(iter(services.values()))
    return service.obj.spec

def get_clickhouse_pod_spec(kube):
    pods = kube.get_pods(
        namespace="posthog",
        labels={
            "clickhouse.altinity.com/namespace": "posthog",
            "clickhouse.altinity.com/chi": "posthog",
        },
    )
    pod = next(iter(pods.values()))
    return pod.obj.spec
