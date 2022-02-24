import json

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

def get_clickhouse_pods(kube):
    return kube.get_pods(
        namespace="posthog",
        labels={
            "clickhouse.altinity.com/namespace": "posthog",
            "clickhouse.altinity.com/chi": "posthog",
        },
    )

def get_clickhouse_pod_spec(kube):
    pod = next(iter(get_clickhouse_pods(kube).values()))
    return pod.obj.spec

def run_query_on_clickhouse_nodes(kube, user, password, query):
    pod = next(iter(get_clickhouse_pods(kube).values()))
    response = pod.http_proxy_get(
        "/",
        {
            "user": user,
            "password": password,
            "query": query,
            "default_format": "JSON",
        },
    )

    assert response.status == 200, f"Clickhouse query failed. status={response.status}, data={response.data}"

    return response.json().get('data')

def get_clickhouse_table_counts_on_all_nodes(kube, user = "posthog", password = "kubetest123"):
    table_counts_rows = run_query_on_clickhouse_nodes(
        kube,
        user=user,
        password=password,
        query="""
            SELECT hostName() AS hostname, count() AS table_count
            FROM clusterAllReplicas('posthog', system, tables)
            WHERE database = 'posthog'
            GROUP BY hostname
        """,
    )

    number_of_hosts = len(table_counts_rows)
    table_counts = [row["table_count"] for row in table_counts_rows]

    return number_of_hosts, table_counts
