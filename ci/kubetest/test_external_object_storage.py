from base64 import b64encode

import pytest

from helpers.utils import NAMESPACE, apply_manifest, create_namespace_if_not_exists, exec_subprocess, install_chart


def test_can_use_external_object_storage_with_secret_specified():
    create_namespace_if_not_exists()

    # MinIO credentials
    username = "some-user"
    password = "some-password"

    # Add in a secret for minio access
    apply_manifest(
        manifest_yaml=f"""
            apiVersion: v1
            kind: Secret
            data:
                root-user: {b64encode(username.encode()).decode()}
                root-password: {b64encode(password.encode()).decode()}
            metadata:
                name: object-storage-config
                namespace: {NAMESPACE}
        """
    )

    # Use a separately installed minio as the external object storage
    exec_subprocess(
        cmd=f"""
            helm install minio minio \
                --debug --namespace {NAMESPACE} \
                --set persistence.enabled=false \
                --set mode=standalone \
                --set resources.requests.memory=100Mi \
                --set buckets[0].name=posthog \
                --set buckets[0].policy=none \
                --set buckets[0].purge=false \
                --set rootUser={username} \
                --set rootPassword={password} \
                --repo https://charts.min.io/
        """
    )

    # Install PostHog with internal MinIO disabled, but configured to point to
    # separate MinIO installation.
    install_chart(
        values="""
            minio:
                enabled: false
            externalObjectStorage:
                endpoint: http://minio
                bucket: posthog
                existingSecret: object-storage-config
        """
    )
