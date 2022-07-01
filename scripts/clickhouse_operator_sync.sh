#!/usr/bin/env bash
#
# This tool fetches and formats 'Altinity/clickhouse-operator'
# k8s resource definitions into our chart.
#
# Why do we need this? The 'clickhouse-operator' doesn't expose a Helm
# package so we need to collect and bundle the resources by our own.
#

set -e
set -u
set -o pipefail

CURRENT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd -P)"
CHART_PATH_RAW="${CURRENT_DIR}/../charts/posthog"
CHART_PATH=$(cd "$CHART_PATH_RAW" 2> /dev/null && pwd -P)
TMP_FOLDER="$(mktemp -d)"
trap 'rm -rf -- "$TMP_FOLDER"' EXIT

CLICKHOUSE_OPERATOR_TAG="0.18.4"
URL="https://raw.githubusercontent.com/Altinity/clickhouse-operator/${CLICKHOUSE_OPERATOR_TAG}/deploy/operator/clickhouse-operator-install-template.yaml"

#
# Download the 'altinity/clickhouse-operator' definition and save it as temporary file.
#
# see: https://github.com/Altinity/clickhouse-operator/blob/master/docs/quick_start.md#in-case-you-can-not-run-scripts-from-internet-in-your-protected-environment
#
OPERATOR_NAMESPACE="PLACEHOLDER"
METRICS_EXPORTER_NAMESPACE="${OPERATOR_NAMESPACE}"
# NOTE: we pin to 0.19.0 here which is different to the 0.16.1 manifest version.
# Prior to pinning we were specifying latest, so to ensure that the version
# doesn't change on existing installs we pin to latest as of writing, thereby
# mitigating the possibility that chart will unexpectedly update, while also
# maintaining current functionality.
OPERATOR_IMAGE="${OPERATOR_IMAGE:-altinity/clickhouse-operator:0.19.0}"
METRICS_EXPORTER_IMAGE="${METRICS_EXPORTER_IMAGE:-altinity/metrics-exporter:latest}"

curl -s "${URL}" | \
    OPERATOR_IMAGE="${OPERATOR_IMAGE}" \
    OPERATOR_NAMESPACE="${OPERATOR_NAMESPACE}" \
    METRICS_EXPORTER_IMAGE="${METRICS_EXPORTER_IMAGE}" \
    METRICS_EXPORTER_NAMESPACE="${METRICS_EXPORTER_NAMESPACE}" \
    envsubst > "$TMP_FOLDER/clickhouse-operator.yaml"

#
# Use 'altinity/clickhouse-operator' definition file we fetched and parsed and slice it
# in different files, based on the resource kind
#
go install github.com/patrickdappollonio/kubectl-slice@v1.2.3

rm -rf "${CHART_PATH}/templates/clickhouse-operator"
mkdir -p "${CHART_PATH}/templates/clickhouse-operator"
kubectl-slice -f "$TMP_FOLDER/clickhouse-operator.yaml" -o "${CHART_PATH}/crds" --include-kind CustomResourceDefinition --template '{{.metadata.name}}.yaml'
kubectl-slice -f "$TMP_FOLDER/clickhouse-operator.yaml" -o "${CHART_PATH}/templates/clickhouse-operator" --exclude-kind CustomResourceDefinition --template '{{.kind | lower}}.yaml'

#
# Add a {{- if .Values.clickhouse.enabled }} and {{- end }} at the end of each non-crds resource.
# Also replace 'namespace: posthog' and '#namespace: posthog' with
# {{ .Values.clickhouse.namespace | default .Release.Namespace }} so we can keep customizing where the operator is installed
#
FILES="${CHART_PATH}/templates/clickhouse-operator/*"
for f in $FILES
do
    # NOTE: previously we were using sed with the `-i` option to specify that we
    # should to the modifications in place. The option behaviour between GNU and
    # BSD versions, hence here we opt for using perl instead.
    perl -pi -e 'print "{{- if .Values.clickhouse.enabled }}\n" if $. == 1' "$f"

    echo "{{- end }}" >> "$f"

    perl -pi -e 's/PLACEHOLDER$/{{ .Values.clickhouse.namespace | default .Release.Namespace }}/g' "$f"
    perl -pi -e 's/#namespace: /namespace: /g' "$f"
done
