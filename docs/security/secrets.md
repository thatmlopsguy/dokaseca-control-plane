# Vault Secrets Organization

This document outlines the structure and organization of secrets within HashiCorp Vault for the different teams in Doka
Seca.

## Secret Hierarchy Overview

```sh
vault/
├── platform/
│   ├── s3/
│   │   ├── velero/
│   │   ├── vm/
│   │   ├── tempo/
│   │   └── loki/
│   └── postgres/
│       ├── common/
│       ├── dev/
│       ├── stg/
│       └── prod/
├── team-a/
│   ├── dev/
│   ├── stg/
│   └── prod/
├── team-b/
│   ├── dev/
│   ├── stg/
│   └── prod/
└── team-c/
    ├── dev/
    ├── stg/
    └── prod/
```

## Access Control Policies

Each team has access to their own secrets path, with platform team having additional access to infrastructure-related secrets.

### Platform Team

The Platform Team manages infrastructure-level secrets and has access to:

- S3 bucket credentials for backups (Velero)
- S3 bucket credentials for logs (Loki), traces (Tempo) and Metrics (Victoria Metrics)
- PostgreSQL database credentials for all environments
- Shared database credentials for platform services (Backstage, Keycloak, DevLake, LiteLLM, Langfuse)

```hcl
# platform-policy.hcl
path "vault/platform/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}
```

### Team A, B, and C

Each team has access only to their respective secrets paths, segregated by environment:

```hcl
# team-a-policy.hcl
path "vault/team-a/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}
```

Similar policies exist for Team B and Team C.

## Secret Types and Standards

### Platform Secrets

#### S3 Bucket Credentials

S3 bucket credentials are stored in the following format:

```sh
vault/platform/s3/velero
vault/platform/s3/loki
```

Each secret contains:

- `access_key`: AWS access key ID
- `secret_key`: AWS secret access key
- `bucket`: Bucket name
- `endpoint`: S3 endpoint URL (for non-AWS S3 providers)
- `region`: AWS region

#### PostgreSQL Credentials

Database credentials are stored in the following format:

```sh
vault/platform/postgres/common/backstage
vault/platform/postgres/common/keycloak
vault/platform/postgres/common/devlake
vault/platform/postgres/common/litellm
vault/platform/postgres/common/langfuse
```

Each secret contains:

- `username`: Database username
- `password`: Database password
- `host`: Database host
- `port`: Database port
- `database`: Database name
- `sslmode`: SSL mode (disable, require, etc.)

##### Common Platform Services

The following platform services use database credentials shared across all environments:

- **Backstage**: Developer portal credentials
- **Keycloak**: Identity and access management credentials
- **DevLake**: DevOps metrics platform credentials
- **LiteLLM**: LLM proxy service credentials
- **Langfuse**: LLM observability service credentials

### Application Team Secrets

Application teams store their secrets following this pattern:

```sh
vault/team-a/dev/app-name/config
vault/team-a/dev/app-name/api-keys
vault/team-a/dev/app-name/certificates
```

## Integration with Kubernetes

Secrets from Vault are synced to Kubernetes using the External Secrets Operator.

The following CRDs are used:

- `ClusterSecretStore`: Configures the connection to Vault
- `ExternalSecret`: Maps Vault secrets to Kubernetes secrets

## Rotating Secrets

### Scheduled Rotation

Critical secrets like database credentials are rotated on a regular schedule:

- Production: Every 30 days
- Staging: Every 60 days
- Development: Every 90 days

### On-demand Rotation

In case of security incidents, secrets can be immediately rotated using:

```bash
# Using the vault CLI TODO
./scripts/vault-rotate.sh platform/postgres/dev/app-db

# Or manually through the Vault UI
```

## Audit and Compliance (SOC 2)

All access to secrets is logged in Vault's audit log, which is integrated with our central logging system.
Regular compliance reports are generated from these logs to ensure:

- No unauthorized access attempts
- Proper rotation schedules are maintained
- Policy compliance across all teams

## Backup and Recovery

Vault's storage backend is regularly backed up using Velero. In case of disaster recovery, follow the procedure in
`docs/vault-setup.md` to restore from backup.

## Vault + CSI Secrets Store Driver (direct mount)

Doka Seca also supports integrating HashiCorp Vault with the Kubernetes Secrets Store CSI Driver.
In this flow Vault -> CSI Secrets Store Driver -> Volume mount -> Application, the CSI provider fetches secrets directly
from Vault and mounts them into the pod filesystem (for example: `/secrets/credentials`). When rotation is enabled the
driver refreshes the mounted file periodically without requiring a pod restart.

High-level steps:

- Install the Secrets Store CSI Driver and the HashiCorp Vault provider for the driver.
- Create a `SecretProviderClass` that tells the CSI driver which Vault address, role and secret paths to use.
- Add a CSI volume to your `Pod`/`Deployment` and mount it at the desired path (e.g. `/secrets`).
- (Optional) Enable rotation/refresh according to the provider and driver configuration so files are updated automatically.

Example `SecretProviderClass` (minimal):

```yaml
apiVersion: secrets-store.csi.x-k8s.io/v1
kind: SecretProviderClass
metadata:
  name: vault-secrets
spec:
  provider: vault
  parameters:
    vaultAddress: "https://vault.default.svc:8200"
    roleName: "k8s-role"
    # provider-specific "objects" listing the Vault paths/keys to fetch
    objects: |
      - objectName: "app-credentials"
        secretPath: "secret/data/platform/app"
        secretKey: "credentials"
```

Example `Pod` snippet mounting the CSI volume at `/secrets`:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: app-with-vault-csi
spec:
  containers:
  - name: app
    image: your-image:tag
    volumeMounts:
    - name: secrets-store-inline
      mountPath: /secrets
      readOnly: true
  volumes:
  - name: secrets-store-inline
    csi:
      driver: secrets-store.csi.k8s.io
      readOnly: true
      volumeAttributes:
        secretProviderClass: "vault-secrets"
```

With the configuration above, the secret value referenced by `objectName`/`secretKey` will be available as a file under
`/secrets` (for example `/secrets/credentials` or `/secrets/app-credentials` depending on the provider configuration).

Rotation and refresh notes:

- The Secrets Store CSI Driver supports refreshing mounted secrets so they are updated in-place. The exact method and configuration keys for enabling rotation depend on the CSI provider (Vault provider) and the driver version. Consult the provider docs for supported rotation/refresh parameters and recommended polling intervals.
- When rotation is enabled, the mounted file(s) are updated by the driver; most applications can pick up credential changes without restarting, but verify your application reload semantics (for example, re-read files or handle SIGHUP if required).
- If you also need a Kubernetes `Secret` resource created from the Vault secret (for compatibility with apps expecting `Secret` objects), use the `secretObjects` feature of the Secrets Store CSI Driver to sync the mounted secrets into Kubernetes `Secret` resources.

See the Secrets Store CSI Driver and Vault provider documentation for installation steps, provider-specific parameters and best practices for rotation and RBAC.

## References

- [Argo CD with Vault and the CSI Secrets Store Driver demo](https://github.com/kostis-codefresh/argocd-csi-secret-store-example)
