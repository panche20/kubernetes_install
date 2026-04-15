#!/bin/bash

set -e  # Exit on error

echo "🚀 Starting Docker installation..."

# Remove old versions
echo "🧹 Removing old Docker versions..."
sudo apt remove -y $(dpkg --get-selections docker.io docker-compose docker-compose-v2 docker-doc podman-docker containerd runc 2>/dev/null | cut -f1) || true

# Update system
echo "📦 Updating system..."
sudo apt update

# Install prerequisites
echo "🔧 Installing required packages..."
sudo apt install -y ca-certificates curl

# Add Docker GPG key
echo "🔑 Adding Docker GPG key..."
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add Docker repo
echo "📁 Adding Docker repository..."
echo \
"Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo ${UBUNTU_CODENAME:-$VERSION_CODENAME})
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc" | sudo tee /etc/apt/sources.list.d/docker.sources > /dev/null

# Update again
sudo apt update

# Install Docker
echo "🐳 Installing Docker..."
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Start & enable Docker
echo "⚙️ Starting Docker service..."
sudo systemctl enable docker
sudo systemctl start docker

# Add user to docker group
echo "👤 Adding current user to docker group..."
sudo usermod -aG docker $USER

echo "✅ Docker installed successfully!"

# Verify installation
docker --version
docker compose version

echo "⚠️ Please logout and login again (or run 'newgrp docker') to use Docker without sudo."
