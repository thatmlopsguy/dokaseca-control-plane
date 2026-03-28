## Ingress Controllers

Ingress controllers manage external access to services within the cluster.

### NGINX Ingress Controller

```sh
# Install NGINX Ingress Controller
kubectl apply -f kubernetes/ingress-nginx/deploy.yaml

# Verify installation
kubectl get pods -n ingress-nginx
```

### Traefik

[Traefik](https://traefik.io/traefik/) is a modern HTTP reverse proxy and load balancer.

```sh
# Install Traefik using Helm
helm repo add traefik https://helm.traefik.io/traefik
helm install traefik traefik/traefik -n traefik --create-namespace
```
