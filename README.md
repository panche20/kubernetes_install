# Kubernetes Installation script

*First step is to clone this repo:*

- provide executable permissions to all the file
- first installation script should be install_docker.sh & then run any file or which ever kubernetes platform you want. 

## Steps to create EKS Cluster

- Install kubectl first using below mentioned commands

```
# 1. Download the kubectl v1.34 binary directly
curl -LO "https://dl.k8s.io/release/v1.34.0/bin/linux/amd64/kubectl"

# 2. Make it executable and move it to your PATH
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/

# 3. Verify it works
kubectl version --client
```

- Please create eks-cluster.yaml file attached in this repo.

```
eksctl create cluster -f cluster.yaml
```
