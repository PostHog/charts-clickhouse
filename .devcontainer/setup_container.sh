#/usr/bin/env bash

set -e -o pipefail

# Install k3s
curl -sfL https://get.k3s.io | INSTALL_K3S_CHANNEL=v1.22 INSTALL_K3S_EXEC="--disable=traefik --disable=metrics-server" sh -
sudo apt-get update
sudo apt-get install supervisor
sudo supervisord -c .devcontainer/supervisord.conf
mkdir ~/.kube

until (sudo k3s kubectl version); do
    echo "Waiting for k3s to start..."
    ((c++)) && ((c==10)) && break
    sleep 1
done

sudo k3s kubectl config view --raw > ~/.kube/config

# Install k9s for easy debugging https://k9scli.io/
curl -sS https://webinstall.dev/k9s | bash

# Install anything we need to kubetest tests
pip install -r ci/kubetest/requirements.txt

# Install k6 so we can run load tests
sudo gpg --no-default-keyring --keyring /usr/share/keyrings/k6-archive-keyring.gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C5AD17C747E3415A3642D57D77C6C491D6AC1D69
echo "deb [signed-by=/usr/share/keyrings/k6-archive-keyring.gpg] https://dl.k6.io/deb stable main" | sudo tee /etc/apt/sources.list.d/k6.list
sudo apt-get update
sudo apt-get install k6

echo "printf 'Hello 🦔! To install PostHog into k8s run this:\n\n "helm upgrade --install posthog charts/posthog -f .devcontainer/values.yml --namespace posthog --create-namespace"\n'" >> ~/.zshrc
