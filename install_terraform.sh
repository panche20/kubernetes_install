#!/bin/bash

set -e  # Exit on any error

echo "🚀 Starting Terraform installation..."

# Update system packages
echo "📦 Updating package list..."
sudo apt-get update -y

# Install required dependencies
echo "🔧 Installing dependencies..."
sudo apt-get install -y gnupg software-properties-common curl

# Add HashiCorp GPG key
echo "🔑 Adding HashiCorp GPG key..."
wget -O- https://apt.releases.hashicorp.com/gpg | \
  sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

# Add HashiCorp repository
echo "📁 Adding HashiCorp repository..."
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list > /dev/null

# Update again after adding repo
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
terraform -install-autocomplete

# Reload shell config
echo "🔄 Reloading bashrc..."
source ~/.bashrc

echo "🎉 Terraform installation completed successfully!"
