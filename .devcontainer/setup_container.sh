#/usr/bin/env bash

set -e -o pipefail

# Setup a cluster with kind + nginx ingress

# Install kind so we can create a cluster as per
# https://kind.sigs.k8s.io/docs/user/quick-start/#installing-from-release-binaries
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.14.0/kind-linux-amd64
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
  # nginx ingress
  - containerPort: 80
    hostPort: 8000
    protocol: TCP
EOF

# Port forward a range or ports above 30000 to the kind worker node so we can
# easily expose services as node points and be able to interact with them
# locally. It's possible to instruct kind to map these ports, but it seems you
# need to recreate the cluster for these to take affect.
# NOTE: I tried to use `docker-proxy` to avoid needing to install another dep.
# but the process exits immediately with a non-zero status code.
sudo apt-get update
sudo apt-get install socat
NODE_IP=$(kubectl get nodes kind-control-plane --template '{{(index .status.addresses 0).address}}')
seq 30000 30010 | xargs -I{} bash -c "socat TCP4-LISTEN:{},fork TCP4:$NODE_IP:{} &"

# Then provision the nginx controller, e.g.
# https://kind.sigs.k8s.io/docs/user/ingress/#ingress-nginx
# NOTE: I've pinned the version here
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/d8c9a6c238f714587da4d2ac2dcd0d3d39419ccf/deploy/static/provider/kind/deploy.yaml

# Install k9s for easy debugging https://k9scli.io/
curl -sS https://webinstall.dev/k9s | bash

# Install anything we need to kubetest tests
pip install -r ci/kubetest/requirements.txt

# Install k6 so we can run load tests
sudo gpg --no-default-keyring --keyring /usr/share/keyrings/k6-archive-keyring.gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C5AD17C747E3415A3642D57D77C6C491D6AC1D69
echo "deb [signed-by=/usr/share/keyrings/k6-archive-keyring.gpg] https://dl.k6.io/deb stable main" | sudo tee /etc/apt/sources.list.d/k6.list
sudo apt-get update
sudo apt-get install k6

echo "printf 'Hello 🦔! To install PostHog into k8s run this:\n\n "helm upgrade --install posthog charts/posthog -f .devcontainer/values.yml --namespace posthog"\n'" >> ~/.zshrc
