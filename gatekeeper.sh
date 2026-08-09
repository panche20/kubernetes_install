kubectl apply -f \
  https://raw.githubusercontent.com/open-policy-agent/gatekeeper/master/deploy/gatekeeper.yaml

# Watch it come up
kubectl get pods -n gatekeeper-system -w

# What deployed:
# gatekeeper-controller-manager  — webhook server (ValidatingWebhook)
# gatekeeper-audit               — scans existing resources for violations
