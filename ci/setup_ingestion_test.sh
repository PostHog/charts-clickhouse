#!/usr/bin/env sh
#
# This script setup PostHog in DEV mode to do ingestion testing
#

WEB_POD=$(kubectl get pods -n posthog -l role=web -o jsonpath="{.items[].metadata.name}")
kubectl exec "$WEB_POD" -n posthog -- python manage.py setup_dev --no-data
