#!/bin/bash

# Update the local package metadata
echo "Checking for updates..."
sudo apt-get update

# Upgrade only Terraform to the latest version available in the repo
echo "Upgrading Terraform..."
sudo apt-get install --only-upgrade terraform -y

# Verify the new version
echo "Current Version:"
terraform --version
