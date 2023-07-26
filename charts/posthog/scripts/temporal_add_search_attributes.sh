#!/bin/bash

until temporal operator search-attribute list --namespace $TEMPORAL_NAMESPACE
do
    echo "Waiting for namespace cache to refresh..."
    sleep 1
done
echo "Namespace cache refreshed."

echo "Adding search attributes."
temporal operator search-attribute create -y --namespace $TEMPORAL_NAMESPACE \
        --name DestinationId --type Text \
        --name DestinationType --type Text \
        --name TeamId --type Int \
        --name TeamName --type Text \
        --name BackfillId --type Int \
        --name BatchExportId --type Text
