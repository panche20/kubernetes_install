#!/bin/bash

set -e  # Exit immediately if a command fails

echo "🚀 Starting Minikube & kubectl installation..."

# Update system
echo "📦 Updating system..."
sudo apt update

# Install dependencies
echo "🔧 Installing dependencies..."
sudo apt install -y curl conntrack

# Install kubectl
echo "⬇️ Installing kubectl..."
KUBECTL_VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt)

curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

# Verify kubectl
echo "✅ Verifying kubectl..."
kubectl version --client

# Install Minikube
echo "⬇️ Installing Minikube..."
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube

# Verify Minikube
echo "✅ Verifying Minikube..."
minikube version

# Start Minikube using Docker driver + Calico CNI
echo "🐳 Starting Minikube cluster with Calico CNI..."
minikube start --driver=docker --cni=calico

# Verify cluster
echo "🔍 Checking cluster status..."
kubectl cluster-info
kubectl get nodes

# Verify Calico pods
echo "🧪 Verifying Calico installation..."
kubectl get pods -n kube-system | grep calico || true

echo "🎉 Minikube setup with Calico complete!"
