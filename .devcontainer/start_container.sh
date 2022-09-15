#/usr/bin/env bash

set -e -o pipefail

sudo k3s server --disable=traefik --disable=metrics-server --write-kubeconfig-mode=644 --docker &

mkdir -p ~/.kube

until (sudo k3s kubectl version); do
    echo "Waiting for k3s to start..."
    ((c++)) && ((c==10)) && break
    sleep 1
done

sudo k3s kubectl config view --raw > ~/.kube/config
