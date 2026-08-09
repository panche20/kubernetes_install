# Add Falco Helm repo
helm repo add falcosecurity https://falcosecurity.github.io/charts
helm repo update

# Install Falco with Disabled Redis Persistence
helm install falco falcosecurity/falco \
  --namespace falco \
  --create-namespace \
  --set driver.type=modern-ebpf \
  --set falcosidekick.enabled=true \
  --set falcosidekick.webui.enabled=true \
  --set falcosidekick.webui.redis.storageEnabled=false \
  --set tty=true

# Watch Falco come up — takes 2-3 minutes (compiles eBPF probe)
kubectl get pods -n falco -w
