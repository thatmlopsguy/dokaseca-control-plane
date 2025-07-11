# External Secrets Operator Multi-Tenancy Configuration

Date: 2025-07-11

## Status

Proposed

## Context

DoKa Seca requires a secure and scalable secret management solution that supports multi-tenancy across different teams and environments. The current challenges include:

- **Secret Management Complexity**: Manual secret management across multiple namespaces and environments
- **Security Isolation**: Need for proper tenant isolation to prevent cross-namespace secret access
- **Zero Secret Problem**: Chicken-and-egg problem where External Secrets Operator needs initial secrets to access external secret stores
- **Vault Integration**: Requirement to integrate with HashiCorp Vault as the central secret store
- **Scalability**: Solution must scale across multiple teams, namespaces, and environments
- **Compliance**: Need for proper audit trails and access controls for secret access

The platform needs a solution that provides tenant isolation while solving the bootstrap problem of initial secret provisioning.

## Decision

We will implement External Secrets Operator (ESO) with a multi-tenancy configuration using the following architecture:

### **1. Cluster-Level Bootstrap Configuration**

Deploy a single **Cluster Secret Store** (`vault-infra`) that has elevated privileges to:

- Access a dedicated bootstrap path in Vault (`/secret/platform/bootstrap/`)
- Create and manage initial authentication secrets for tenant-specific Secret Stores
- Provide the initial secrets needed to solve the zero secret problem

### **2. Namespace-Level Tenant Isolation**

Deploy a **Secret Store** (`vault-{tenant-name}`) in each tenant namespace that:

- Has access only to tenant-specific paths in Vault (`/secret/tenants/{namespace}/`)
- Uses authentication credentials provided by the Cluster Secret Store
- Provides isolated secret management for each tenant

### **3. Vault Path Structure**

Organize Vault secrets with clear tenant boundaries:

```text
/secret/
├── tenants/
│   ├── tenant-a/
│   │   ├── database-credentials
│   │   └── api-keys
│   ├── tenant-b/
│   │   ├── database-credentials
│   │   └── certificates
│   └── tenant-c/
│       ├── database-credentials
│       └── certificates
└── platform/                    # Platform team exclusive access
    ├── bootstrap/               # Contains tenant Secret Store auth credentials
    │   ├── tenant-a-auth        # Auth credentials for tenant-a Secret Store
    │   ├── tenant-b-auth        # Auth credentials for tenant-b Secret Store
    │   └── tenant-c-auth        # Auth credentials for tenant-c Secret Store
    ├── shared-services/  
    │   ├── monitoring-config
    │   ├── backup-credentials
    │   └── cluster-certificates
    └── infrastructure/
        ├── terraform-state-backend
        └── registry-credentials
```

**Note**: The `bootstrap/` folder is nested under the `platform/` path, ensuring that only the platform team has access
to tenant authentication credentials. This maintains the security boundary between platform operations and tenant operations.

### **4. Naming Conventions**

The multi-tenancy configuration uses a consistent naming scheme:

- **Cluster Secret Store**: `vault-infra` - Manages platform-level infrastructure secrets and bootstrap credentials
- **Tenant Secret Stores**: `vault-{tenant-name}` - Each tenant has a dedicated Secret Store named after the tenant
- **Service Accounts**:
  - Infrastructure: `external-secrets-infra` (in `external-secrets` namespace)
  - Tenant: `external-secrets-{tenant-name}` (in respective tenant namespace)
- **Vault Roles**:
  - Bootstrap: `bootstrap-role` (for infrastructure access)
  - Tenant: `{tenant-namespace}-role` (for tenant-specific access)

This naming convention ensures clear separation between infrastructure and tenant resources while maintaining consistency across the platform.

### **5. Implementation Components**

#### **Cluster Secret Store Configuration**

```yaml
apiVersion: external-secrets.io/v1beta1
kind: ClusterSecretStore
metadata:
  name: vault-infra
spec:
  provider:
    vault:
      server: "https://vault.dokaseca.local"
      path: "secret"
      version: "v2"
      auth:
        kubernetes:
          mountPath: "kubernetes"
          role: "bootstrap-role"
          serviceAccountRef:
            name: "external-secrets-infra"
            namespace: "external-secrets"
```

#### **Namespace Secret Store Template**

```yaml
apiVersion: external-secrets.io/v1beta1
kind: SecretStore
metadata:
  name: vault-${TENANT_NAME}
  namespace: ${TENANT_NAMESPACE}
spec:
  provider:
    vault:
      server: "https://vault.dokaseca.local"
      path: "secret"
      version: "v2"
      auth:
        kubernetes:
          mountPath: "kubernetes"
          role: "${TENANT_NAMESPACE}-role"
          serviceAccountRef:
            name: "external-secrets-${TENANT_NAME}"
            namespace: ${TENANT_NAMESPACE}
```

### **6. Vault Policies and Roles**

#### **Platform Team Policy**

```hcl
# Platform team policy for full Vault access
path "secret/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}
path "secret/data/*" {
  capabilities = ["create", "read", "update", "delete"]
}
path "secret/metadata/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}
```

#### **Bootstrap Policy**

```hcl
# Bootstrap policy for cluster-wide secret store
path "secret/data/platform/bootstrap/*" {
  capabilities = ["read"]
}
path "secret/metadata/platform/bootstrap/*" {
  capabilities = ["list", "read"]
}
```

#### **Tenant Policy Template**

```hcl
# Policy for tenant-specific access
path "secret/data/tenants/{{identity.entity.aliases.MOUNT_ACCESSOR.metadata.service_account_namespace}}/*" {
  capabilities = ["create", "read", "update", "delete"]
}
path "secret/metadata/tenants/{{identity.entity.aliases.MOUNT_ACCESSOR.metadata.service_account_namespace}}/*" {
  capabilities = ["list", "read", "delete"]
}
```

#### **Shared Services Policy**

```hcl
# Policy for shared services (platform team exclusive)
path "secret/data/platform/bootstrap/*" {
  capabilities = ["create", "read", "update", "delete"]
}
path "secret/metadata/platform/bootstrap/*" {
  capabilities = ["list", "read", "delete"]
}
path "secret/data/platform/shared-services/*" {
  capabilities = ["create", "read", "update", "delete"]
}
path "secret/metadata/platform/shared-services/*" {
  capabilities = ["list", "read", "delete"]
}
path "secret/data/platform/infrastructure/*" {
  capabilities = ["create", "read", "update", "delete"]
}
path "secret/metadata/platform/infrastructure/*" {
  capabilities = ["list", "read", "delete"]
}
```

### **7. Automated Deployment Process**

1. **Bootstrap Phase**: Deploy `vault-infra` Cluster Secret Store with elevated Vault access to platform paths
2. **Credential Generation**: `vault-infra` creates authentication credentials for each tenant in `/secret/platform/bootstrap/`
3. **Tenant Deployment**: Deploy namespace-specific `vault-{tenant-name}` Secret Stores using bootstrap credentials
4. **Secret Synchronization**: External Secrets begin syncing tenant-specific secrets from `/secret/tenants/{namespace}/`

## Consequences

### **Positive Consequences**

- **Security Isolation**: Each tenant can only access their designated Vault paths
- **Zero Secret Resolution**: Bootstrap mechanism solves the initial secret problem
- **Scalability**: New tenants can be onboarded without manual secret management
- **Audit Trail**: Complete audit trail of secret access through Vault logs
- **GitOps Integration**: Secret Store configurations can be managed through GitOps
- **Disaster Recovery**: Secrets can be restored from Vault during cluster rebuilds
- **Compliance**: Proper separation of concerns meets security compliance requirements

### **Negative Consequences**

- **Vault Dependency**: Strong dependency on Vault availability for secret operations
- **Bootstrap Security**: Bootstrap credentials become a critical security component
- **Monitoring Overhead**: Need to monitor multiple Secret Stores across namespaces

## Configuration Examples

### **Bootstrap External Secret**

```yaml
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: tenant-a-bootstrap
  namespace: external-secrets
spec:
  refreshInterval: 1h
  secretStoreRef:
    name: vault-infra
    kind: ClusterSecretStore
  target:
    name: tenant-a-vault-auth
    namespace: tenant-a
  data:
  - secretKey: token
    remoteRef:
      key: platform/bootstrap/tenant-a-auth
      property: token
```

### **Tenant External Secret**

```yaml
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: database-credentials
  namespace: tenant-a
spec:
  refreshInterval: 15m
  secretStoreRef:
    name: vault-tenant-a
    kind: SecretStore
  target:
    name: database-secret
    namespace: tenant-a
  data:
  - secretKey: username
    remoteRef:
      key: tenants/tenant-a/database-credentials
      property: username
  - secretKey: password
    remoteRef:
      key: tenants/tenant-a/database-credentials
      property: password
```

## Monitoring and Alerting

### **Key Metrics**

- Secret Store connection status
- Secret synchronization success/failure rates
- Vault authentication errors
- Secret refresh latency

### **Alert Rules**

```yaml
groups:
- name: external-secrets
  rules:
  - alert: SecretStoreDown
    expr: external_secrets_sync_calls_error > 0
    for: 5m
    labels:
      severity: critical
    annotations:
      summary: "Secret Store {{ $labels.name }} is failing"

  - alert: SecretSyncFailed
    expr: external_secrets_sync_calls_error > external_secrets_sync_calls_total * 0.1
    for: 2m
    labels:
      severity: warning
    annotations:
      summary: "High error rate for secret synchronization"
```

## Security Considerations

### **Access Control**

- **Platform Team**: Full administrative access to all Vault paths for platform management and operations, including:
  - Bootstrap credentials (`/secret/platform/bootstrap/`) for tenant Secret Store authentication
  - Shared services infrastructure (`/secret/platform/shared-services/`)
  - Core infrastructure secrets (`/secret/platform/infrastructure/`)
- **Vault Policies**: Strict path-based access control for tenant isolation
- **Kubernetes RBAC**: Controls Secret Store access within Kubernetes clusters
- **Service Accounts**: Minimal required permissions for tenant-specific operations
- **Bootstrap Isolation**: Bootstrap credentials stored under platform namespace ensure only the platform team can manage tenant onboarding

### **Secret Rotation**

- Automated rotation of Vault authentication tokens
- Regular rotation of bootstrap credentials
- Monitoring for expired or expiring secrets

### **Audit and Compliance**

- All secret access logged in Vault audit logs
- External Secrets Operator provides operation metrics
- Regular security reviews of access patterns
- Platform team actions audited through Vault's comprehensive logging

## References

- [External Secrets Operator Multi Tenancy Documentation](hhttps://external-secrets.io/latest/guides/multi-tenancy/)
- [HashiCorp Vault Kubernetes Auth Method](https://www.vaultproject.io/docs/auth/kubernetes)
- [Kubernetes Multi-Tenancy Best Practices](https://kubernetes.io/docs/concepts/security/multi-tenancy/)

## Related ADRs

- [ADR-001: Use Architecture Decision Records](001-use-architecture-decision-records.md)

## Authors

- Platform Engineering Team
- Security Team

## Review History

| Date | Reviewer | Status | Comments |
|------|----------|--------|----------|
| 2025-07-11 | Initial | Draft | Initial proposal for review |
