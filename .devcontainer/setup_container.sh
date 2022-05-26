#/usr/bin/env bash

set -e -o pipefail

# Setup a cluster with kind + nginx ingress

# Install kind so we can create a cluster as per
# https://kind.sigs.k8s.io/docs/user/quick-start/#installing-from-release-binaries
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.11.1/kind-linux-amd64
chmod +x ./kind
mkdir -p ~/.local/bin/
mv ./kind ~/.local/bin/kind

# We use a cluster config that adds ingress-ready=true to each node as per
# https://kind.sigs.k8s.io/docs/user/ingress/#create-cluster
# 
# This should mean you can go to port http://localhost:8000 or
# https://localhost:4430 to view the running posthog app once deployed to the
# cluster, and once VSCode has forwarded the ports
cat <<EOF | kind create cluster --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  kubeadmConfigPatches:
  - |
    kind: InitConfiguration
    nodeRegistration:
      kubeletExtraArgs:
        node-labels: "ingress-ready=true"
  extraPortMappings:
  - containerPort: 80
    hostPort: 8000
    protocol: TCP
  - containerPort: 443
    hostPort: 4430
    protocol: TCP
EOF

# Then provision the nginx controller, e.g.
# https://kind.sigs.k8s.io/docs/user/ingress/#ingress-nginx 
# NOTE: I've pinned the version here
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/d8c9a6c238f714587da4d2ac2dcd0d3d39419ccf/deploy/static/provider/kind/deploy.yaml

# Install k9s for easy debugging https://k9scli.io/
curl -sS https://webinstall.dev/k9s | bash

echo "printf 'Hello 🦔! To install PostHog into k8s run this:\n\n "helm upgrade --install posthog charts/posthog --set cloud=private"\n'" >> ~/.zshrc
