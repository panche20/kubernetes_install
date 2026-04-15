#!/bin/bash

set -e  # Exit on error

echo "🚀 Starting KIND & kubectl installation..."

# Update system
echo "📦 Updating system..."
sudo apt update

# Install dependencies
echo "🔧 Installing dependencies..."
sudo apt install -y curl

# -------------------------------
# Install kubectl (if not exists)
# -------------------------------
if command -v kubectl &> /dev/null
then
    echo "✅ kubectl already installed, skipping..."
else
    echo "⬇️ Installing kubectl..."
    KUBECTL_VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt)

    curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"
    chmod +x kubectl
    sudo mv kubectl /usr/local/bin/
fi

# Verify kubectl
echo "🔍 Verifying kubectl..."
kubectl version --client

# -------------------------------
# Install KIND (if not exists)
# -------------------------------
if command -v kind &> /dev/null
then
    echo "✅ KIND already installed, skipping..."
else
    echo "⬇️ Installing KIND..."
    curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.23.0/kind-linux-amd64
    chmod +x kind
    sudo mv kind /usr/local/bin/
fi

# Verify KIND
echo "🔍 Verifying KIND..."
kind version

# -------------------------------
# Check Docker dependency
# -------------------------------
if ! command -v docker &> /dev/null
then
    echo "❌ Docker is not installed. Please install Docker first."
    exit 1
fi

# -------------------------------
# Create KIND cluster config
# -------------------------------
echo "📄 Creating KIND cluster config..."
cat <<EOF > kind-config.yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
  - role: control-plane
  - role: worker
  - role: worker
EOF

# -------------------------------
# Create cluster (idempotent)
# -------------------------------
if kind get clusters | grep -q "k8s-mastery"
then
    echo "⚠️ Cluster 'k8s-mastery' already exists, skipping creation..."
else
    echo "🐳 Creating KIND cluster..."
    kind create cluster --name k8s-mastery --config kind-config.yaml
fi

# -------------------------------
# Verify cluster
# -------------------------------
echo "🔍 Checking cluster..."
kubectl cluster-info
kubectl get nodes

echo "🎉 KIND cluster setup complete!"
