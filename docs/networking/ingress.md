## Ingress Controllers

Ingress controllers manage external access to services within the cluster.

DoKa Seca supports multiple ingress controllers, with NGINX and Traefik as popular options for HTTP routing
and load balancing. Cilium's built-in ingress controller is also available for high-performance L7 load balancing.

### NGINX Ingress Controller

```hcl
enable_nginx_ingress = true
```

### Traefik

```hcl
enable_traefik = true
```
