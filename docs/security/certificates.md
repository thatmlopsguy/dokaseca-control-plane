# Certificates and TLS

DoKa Seca supports TLS encryption for secure communication between components and with external clients. This includes:
Certificate management, TLS configuration, and best practices for securing communication channels.

Certificates can be managed using Kubernetes Secrets and integrated with Ingress controllers for secure external access.
Cert-manager can be used for automated certificate issuance and renewal.

```hcl
addons = {
  enable_cert_manager = true
}
```

Trust Manager is used for managing trusted certificate authorities (CAs) within the cluster, allowing you to securely
connect to external services with custom CAs.

```hcl
addons = {
  enable_trust_manager = true
}
```

!!! warning "Warning"
    Documentation coming soon!
