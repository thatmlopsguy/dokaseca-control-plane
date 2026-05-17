# Database Setup for DoKa Seca Platform Services

This document outlines the database configuration for platform services in the DoKa Seca project.

## Overview

The platform uses a single PostgreSQL, MySQL and Clickhouse containers with multiple databases for different platform services.
Each service has its own dedicated database, user, and password for isolation and security. Database credentials are stored in
Vault and accessed by services via environment variables.

## Database Structure

Each service has:

- Its own dedicated database
- A unique user with appropriate permissions
- Password-based authentication

## Connection Information

| Service        | Database            | Username            | Default Password        | Connection String                                   |
|----------------|---------------------|---------------------|-------------------------|-----------------------------------------------------|
| Keycloak       | keycloak            | keycloak_user       | keycloak_password       | jdbc:postgresql://postgres:5432/keycloak            |
| Temporal       | temporal            | temporal_user       | temporal_password       | jdbc:postgresql://postgres:5432/temporal            |
| Temporal       | temporal_visibility | temporal_user       | temporal_password       | jdbc:postgresql://postgres:5432/temporal_visibility |
| Backstage      | backstage           | backstage_user      | backstage_password      | jdbc:postgresql://postgres:5432/backstage           |
| LiteLLM        | litellm             | litellm_user        | litellm_password        | jdbc:postgresql://postgres:5432/litellm             |
| Langfuse       | langfuse            | langfuse_user       | langfuse_password       | jdbc:postgresql://postgres:5432/langfuse            |
| Langtrace      | langtrace           | langtrace_user      | langtrace_password      | jdbc:postgresql://postgres:5432/langtrace           |
| Grafana        | grafana             | grafana_user        | grafana_password        | jdbc:postgresql://postgres:5432/grafana             |
| MLflow         | mlflow              | mlflow_user         | mlflow_password         | jdbc:postgresql://postgres:5432/mlflow              |
| Report Portal  | report_portal       | report_portal_user  | report_portal_password  | jdbc:postgresql://postgres:5432/report_portal       |
| Chaos Mesh     | chaos_mesh          | chaos_mesh_user     | chaos_mesh_password     | jdbc:postgresql://postgres:5432/chaos_mesh          |
| Airflow        | airflow             | airflow_user        | airflow_password        | jdbc:postgresql://postgres:5432/airflow             |
| Dagster        | dagster             | dagster_user        | dagster_password        | jdbc:postgresql://postgres:5432/dagster             |
| Superset       | superset            | superset_user       | superset_password       | jdbc:postgresql://postgres:5432/superset            |
| Paralus        | paralus             | paralus_user        | paralus_password        | jdbc:postgresql://postgres:5432/paralus             |
| Harbor         | harbor              | harbor_user         | harbor_password         | jdbc:postgresql://postgres:5432/harbor              |
| Uptrace        | uptrace             | uptrace_user        | uptrace_password        | jdbc:postgresql://postgres:5432/uptrace             |
| Argo Workflows | argo_workflows      | argo_workflows_user | argo_workflows_password | jdbc:postgresql://postgres:5432/argo_workflows      |
| Feast          | feast               | feast_user          | feast_password          | jdbc:postgresql://postgres:5432/feast               |

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

## MySQL/MariaDB

MySQL is used for DevLake. It is configured similarly to PostgreSQL, with credentials stored in Vault and connection information provided in the `.env` file. The MySQL container is defined in the `docker-compose.yml` file and can be accessed using the MySQL client or any compatible database tool.

| Service | Database | Username     | Default Password | Connection String               |
|---------|----------|--------------|------------------|---------------------------------|
| devlake | devlake  | devlake_user | devlake_password | jdbc:mysql://mysql:3306/devlake |
| zipkin  | zipkin   | zipkin_user  | zipkin_password  | jdbc:mysql://mysql:3306/zipkin  |

## MongoDB

MongoDB is used for Litmus. It is configured similarly to PostgreSQL, with credentials stored in Vault and connection
information provided in the `.env` file. The MongoDB container is defined in the `docker-compose.yml` file and can
be accessed using the MongoDB client or any compatible database tool.

| Service  | Database | Username      | Default Password  | Connection String                          |
|----------|----------|---------------|-------------------|--------------------------------------------|
| litmus   | litmus   | litmus_user   | litmus_password   | mongodb://mongodb:27017/litmus            |

## Clickhouse

The Clickhouse database is used for langfuse and signoz. It is configured similarly to PostgreSQL, with credentials stored
in Vault and connection information provided in the `.env` file. The Clickhouse container is defined in the
`docker-compose.yml` file and can be accessed using the Clickhouse client or any compatible database tool.

| Service   | Database  | Username       | Default Password   | Connection String                           |
|-----------|-----------|----------------|--------------------|---------------------------------------------|
| langfuse  | langfuse  | langfuse_user  | langfuse_password  | jdbc:clickhouse://clickhouse:8123/langfuse  |
| langtrace | langtrace | langtrace_user | langtrace_password | jdbc:clickhouse://clickhouse:8123/langtrace |
| signoz    | signoz    | signoz_user    | signoz_password    | jdbc:clickhouse://clickhouse:8123/signoz    |
| uptrace   | uptrace   | uptrace_user   | uptrace_password   | jdbc:clickhouse://clickhouse:8123/uptrace   |

## Cassandra

!!! warning "Warning"
    Documentation coming soon!

## Integration with Vault

Database credentials are stored in Vault following the pattern described in the [secrets documentation](/docs/security/secrets.md):

```sh
# PostgreSQL credentials
vault/platform/postgres/common/dockhand
vault/platform/postgres/common/backstage
vault/platform/postgres/common/keycloak
vault/platform/postgres/common/temporal
vault/platform/postgres/common/litellm
vault/platform/postgres/common/langfuse
vault/platform/postgres/common/langtrace
vault/platform/postgres/common/grafana
vault/platform/postgres/common/mlflow
vault/platform/postgres/common/airflow
vault/platform/postgres/common/dagster
vault/platform/postgres/common/report_portal
vault/platform/postgres/common/chaos_mesh
vault/platform/postgres/common/paralus
vault/platform/postgres/common/superset
vault/platform/postgres/common/harbor
vault/platform/postgres/common/uptrace
vault/platform/postgres/common/argo_workflows
vault/platform/postgres/common/arize_phoenix
vault/platform/postgres/common/feast
# MySQL credentials
vault/platform/mysql/common/devlake
# Clickhouse credentials
vault/platform/clickhouse/common/langfuse
vault/platform/clickhouse/common/langtrace
vault/platform/clickhouse/common/signoz
vault/platform/clickhouse/common/uptrace
# MongoDB credentials
vault/platform/mongodb/common/litmus
```

## Backup and Recovery

Database data is persisted in the `postgres-data` Docker volume.
