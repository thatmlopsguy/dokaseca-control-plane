## Service Mesh

Service meshes provide advanced networking features like traffic management, security, and observability.

### Istio

[Istio](https://istio.io/) is a popular service mesh that enhances security, observability, and traffic management.

```sh
# Install Istio using istioctl
istioctl install --set profile=demo -y

# Enable automatic sidecar injection for a namespace
kubectl label namespace default istio-injection=enabled
```

## Advanced Networking Patterns

### East-West Traffic Control

Implement network policies to control pod-to-pod communication:

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-specific-app
spec:
  podSelector:
    matchLabels:
      app: backend-api
  ingress:
  - from:
    - podSelector:
        matchLabels:
          app: frontend
```

### Multi-cluster Networking

For connecting multiple clusters:

1. Use Cilium Cluster Mesh for direct pod-to-pod communication across clusters
2. Configure service discovery with multi-cluster services
3. Implement cross-cluster load balancing with Skupper or similar tools

### Skupper

Install cli

```sh
$ curl https://skupper.io/install.sh | sh
$ skupper version
client version                 1.8.3
transport version              not-found (no configuration has been provided)
controller version             not-found (no configuration has been provided)
```
