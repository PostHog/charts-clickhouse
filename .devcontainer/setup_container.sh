#/usr/bin/env bash

set -e -o pipefail

# Install k3s
curl -sfL https://get.k3s.io | INSTALL_K3S_CHANNEL=v1.22 INSTALL_K3S_SKIP_ENABLE=true INSTALL_K3S_SKIP_ENABLE=true sh -
sudo apt-get update
sudo apt-get install -y supervisor

cd .devcontainer
sudo supervisord -c supervisord.conf
cd ..

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

curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | sudo bash
sudo chmod a+x /usr/local/bin/helm

# Add helm unittest plugin
helm plugin install https://github.com/quintush/helm-unittest.git --version 0.2.8

echo "printf 'Hello 🦔! To install PostHog into k8s run this:\n\n "helm upgrade --install posthog charts/posthog -f .devcontainer/values.yml --namespace posthog --create-namespace"\n'" >> ~/.zshrc
