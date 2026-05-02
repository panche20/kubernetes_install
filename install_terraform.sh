#!/bin/bash

set -e  # Exit on error

echo "🚀 Starting Terraform installation..."

# Update system
echo "📦 Updating package list..."
sudo apt-get update -y

# Install dependencies
echo "🔧 Installing dependencies..."
sudo apt-get install -y gnupg software-properties-common curl wget unzip

# Detect OS codename
CODENAME=$(lsb_release -cs)
echo "🧠 Detected OS codename: $CODENAME"

# List of supported HashiCorp codenames
SUPPORTED=("focal" "jammy" "bionic")

# Check if codename is supported
if [[ " ${SUPPORTED[@]} " =~ " ${CODENAME} " ]]; then
    REPO_CODENAME=$CODENAME
    echo "✅ Using supported codename: $REPO_CODENAME"
else
    REPO_CODENAME="jammy"
    echo "⚠️ Codename '$CODENAME' not supported. Falling back to: $REPO_CODENAME"
fi

# Add HashiCorp GPG key
echo "🔑 Adding HashiCorp GPG key..."
wget -O- https://apt.releases.hashicorp.com/gpg | \
  sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

# Add HashiCorp repo
echo "📁 Adding HashiCorp repository..."
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com ${REPO_CODENAME} main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list > /dev/null

# Update again
echo "🔄 Updating package list again..."
sudo apt-get update -y

# Install Terraform
echo "⬇️ Installing Terraform..."
sudo apt-get install -y terraform

# Verify installation
echo "✅ Verifying Terraform installation..."
terraform version

# Enable autocomplete
echo "⚙️ Enabling Terraform autocomplete..."
terraform -install-autocomplete || true

# Reload bashrc safely
echo "🔄 Reloading bashrc..."
source ~/.bashrc || true

echo "🎉 Terraform installation completed successfully!"
