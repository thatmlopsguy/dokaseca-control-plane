# Database Setup for DoKa Seca Platform Services

This document outlines the database configuration for platform services in the DoKa Seca project.

## Overview

The platform uses a single PostgreSQL database container with multiple databases for different platform services:

- **Keycloak**: Identity and access management
- **DevLake**: DevOps metrics platform
- **Temporal**: Workflow orchestration
- **Backstage**: Developer portal
- **LiteLLM**: LLM proxy service
- **Langfuse**: LLM observability service

## Database Structure

Each service has:

- Its own dedicated database
- A unique user with appropriate permissions
- Password-based authentication

## Connection Information

| Service   | Database  | Username  | Default Password   | Connection String                         |
|-----------|-----------|-----------|--------------------|-------------------------------------------|
| Keycloak  | keycloak  | keycloak  | keycloak_password  | jdbc:postgresql://postgres:5432/keycloak  |
| DevLake   | devlake   | devlake   | devlake_password   | jdbc:postgresql://postgres:5432/devlake   |
| Temporal  | temporal  | temporal  | temporal_password  | jdbc:postgresql://postgres:5432/temporal  |
| Backstage | backstage | backstage | backstage_password | jdbc:postgresql://postgres:5432/backstage |
| LiteLLM   | litellm   | litellm   | litellm_password   | jdbc:postgresql://postgres:5432/litellm   |
| Langfuse  | langfuse  | langfuse  | langfuse_password  | jdbc:postgresql://postgres:5432/langfuse  |

## Configuration

Database credentials are configured via environment variables in the `.env` file. Copy `.env.example` to `.env` and adjust as needed:

```bash
cp .env.example .env
```

### Environment Variables

- `PG_USER` & `PG_PASSWORD`: PostgreSQL admin credentials
- Service-specific credentials:
  - `KC_DB_USERNAME` & `KC_DB_PASSWORD` (Keycloak)
  - `DL_DB_USERNAME` & `DL_DB_PASSWORD` (DevLake)
  - etc.

## Accessing PostgreSQL

### Via Command Line

Connect to the PostgreSQL container:

```bash
docker compose exec postgres psql -U postgres
```

List databases:

```sql
\l
```

Connect to a specific database:

```sql
\c keycloak
```

### Via External Tool

Connect using your preferred database client:

- Host: localhost
- Port: 5432
- User/Password: As specified in .env file

## Integration with Vault

Database credentials are stored in Vault following the pattern described in the [secrets documentation](/docs/secrets.md):

```sh
vault/platform/postgres/common/backstage
vault/platform/postgres/common/keycloak
vault/platform/postgres/common/devlake
vault/platform/postgres/common/litellm
vault/platform/postgres/common/langfuse
```

## Backup and Recovery

Database data is persisted in the `postgres-data` Docker volume.
