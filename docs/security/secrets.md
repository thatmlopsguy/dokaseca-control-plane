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
vault/platform/s3/velero/dev
vault/platform/s3/velero/stg
vault/platform/s3/velero/prod
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
vault/platform/postgres/dev/app-db
vault/platform/postgres/stg/app-db
vault/platform/postgres/prod/app-db
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

Secrets from Vault are synced to Kubernetes using the External Secrets Operator. The following CRDs are used:

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

## Audit and Compliance

All access to secrets is logged in Vault's audit log, which is integrated with our central logging system. Regular compliance reports are generated from these logs to ensure:

- No unauthorized access attempts
- Proper rotation schedules are maintained
- Policy compliance across all teams

## Backup and Recovery

Vault's storage backend is regularly backed up using Velero. In case of disaster recovery, follow the procedure in
`docs/vault-setup.md` to restore from backup.
