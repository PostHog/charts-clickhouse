#!/usr/bin/env sh
#
# This script setup PostHog in DEV mode to do ingestion testing
#

sleep 10 # TODO: remove this. It was added as the command below often errors with 'unable to upgrade connection: container not found ("posthog-web")'

WEB_POD=$(kubectl get pods --all-namespaces -l app=posthog -l role=web -o jsonpath="{.items[].metadata.name}") # TODO: remove --all-namespaces once DO 1-click install installs PostHog in the `posthog` namespace

kubectl exec "$WEB_POD" -n posthog -- python manage.py setup_dev --no-data
