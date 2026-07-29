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

**# Update ./kube/config file**

```
aws eks update-kubeconfig --name observability
```

## Install Helm

```
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
```

## Install kube-prometheus-stack

```
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
```

## Deploy the chart into a new namespace "monitoring"

```
kubectl create ns monitoring
```

```
cd day-2

helm install monitoring prometheus-community/kube-prometheus-stack \
-n monitoring \
-f ./custom_kube_prometheus_stack.yml
```

## Verify the Installation

```
kubectl get all -n monitoring
```

**Prometheus UI:**

```
kubectl port-forward service/prometheus-operated -n monitoring 9090:9090
```

*NOTE: If you are using an EC2 Instance or Cloud VM, you need to pass --address 0.0.0.0 to the above command. Then you can access the UI on instance-ip:port*

**Grafana UI:**

**Default Credentials:**

- Username: admin
- Password: prom-operator (explicitly configured in custom_kube_prometheus_stack.yml)

*Retrieving Auto-Generated/Actual Credentials: If you did not use the custom configuration file, or if the credentials don't work, retrieve them directly from the Kubernetes secret:*

**Get username:**

```
kubectl get secret --namespace monitoring monitoring-grafana -o jsonpath='{.data.admin-user}' | base64 -d
```

**Get password:**

```
kubectl get secret --namespace monitoring monitoring-grafana -o jsonpath='{.data.admin-password}' | base64 -d
```

*Port-forwarding to access Grafana UI:*

```
kubectl port-forward service/monitoring-grafana -n monitoring 8080:80
```

**Alertmanager UI:**

```
kubectl port-forward service/alertmanager-operated -n monitoring 9093:9093
```

**🧼 Clean UP**

*Uninstall helm chart:*

```
helm uninstall monitoring --namespace monitoring
```

*Delete namespace:*

```
kubectl delete ns monitoring
```

*Delete Cluster & everything else:*

```
eksctl delete cluster --name observability
```
