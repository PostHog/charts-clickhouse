{{/* Common initContainers-wait-for-service-dependencies definition */}}
{{- define "_snippet-initContainers-wait-for-service-dependencies" }}
- name: wait-for-service-dependencies
  image: busybox:1.34
  command:
    - /bin/sh
    - -c
    - |
        set -e
        {{ if .Values.clickhouse.enabled }}
        until (nc -vz "{{ include "posthog.clickhouse.fullname" . }}.$(cat /var/run/secrets/kubernetes.io/serviceaccount/namespace).svc.cluster.local" 8123);
        do
            echo "waiting for ClickHouse"; sleep 1;
        done
        {{ end }}

        until (nc -vz "{{ include "posthog.pgbouncer.host" . }}.$(cat /var/run/secrets/kubernetes.io/serviceaccount/namespace).svc.cluster.local" {{ include "posthog.pgbouncer.port" . }});
        do
            echo "waiting for PgBouncer"; sleep 1;
        done

        {{ if .Values.postgresql.enabled }}
        until (nc -vz "{{ include "posthog.postgresql.host" . }}.$(cat /var/run/secrets/kubernetes.io/serviceaccount/namespace).svc.cluster.local" {{ include "posthog.postgresql.port" . }});
        do
            echo "waiting for PostgreSQL"; sleep 1;
        done
        {{ end }}

        {{ if .Values.redis.enabled }}
        until (nc -vz "{{ include "posthog.redis.host" . }}.$(cat /var/run/secrets/kubernetes.io/serviceaccount/namespace).svc.cluster.local" {{ include "posthog.redis.port" . }});
        do
            echo "waiting for Redis"; sleep 1;
        done
        {{ end }}

        {{ if .Values.kafka.enabled }}

        KAFKA_BROKERS="{{ include "posthog.kafka.brokers" . }}"

        KAFKA_HOST=$(echo $KAFKA_BROKERS | cut -f1 -d:)
        KAFKA_PORT=$(echo $KAFKA_BROKERS | cut -f2 -d:)

        until (nc -vz "$KAFKA_HOST.$(cat /var/run/secrets/kubernetes.io/serviceaccount/namespace).svc.cluster.local" $KAFKA_PORT);
        do
            echo "waiting for Kafka"; sleep 1;
        done
        {{ end }}
{{- end }}
