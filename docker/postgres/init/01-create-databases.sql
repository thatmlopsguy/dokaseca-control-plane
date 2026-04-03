-- Create databases and users for platform services
-- This script runs automatically when the PostgreSQL container starts

-- Keycloak database
CREATE DATABASE keycloak;
CREATE USER keycloak_user WITH PASSWORD 'keycloak_password';
GRANT ALL PRIVILEGES ON DATABASE keycloak TO keycloak_user;
\c keycloak
GRANT ALL ON SCHEMA public TO keycloak_user;

-- DevLake database
CREATE DATABASE devlake;
CREATE USER devlake_user WITH PASSWORD 'devlake_password';
GRANT ALL PRIVILEGES ON DATABASE devlake TO devlake_user;
\c devlake
GRANT ALL ON SCHEMA public TO devlake_user;

-- Temporal databases
CREATE DATABASE temporal;
CREATE DATABASE temporal_visibility;
CREATE USER temporal_user WITH PASSWORD 'temporal_password';
GRANT ALL PRIVILEGES ON DATABASE temporal TO temporal_user;
\c temporal
GRANT ALL ON SCHEMA public TO temporal_user;
GRANT ALL PRIVILEGES ON DATABASE temporal_visibility TO temporal_user;
\c temporal_visibility
GRANT ALL ON SCHEMA public TO temporal_user;

-- Backstage database
CREATE DATABASE backstage;
CREATE USER backstage_user WITH PASSWORD 'backstage_password';
GRANT ALL PRIVILEGES ON DATABASE backstage TO backstage_user;
\c backstage
GRANT ALL ON SCHEMA public TO backstage_user;

-- LiteLLM database
CREATE DATABASE litellm;
CREATE USER litellm_user WITH PASSWORD 'litellm_password';
GRANT ALL PRIVILEGES ON DATABASE litellm TO litellm_user;
\c litellm
GRANT ALL ON SCHEMA public TO litellm_user;

-- Langfuse database
CREATE DATABASE langfuse;
CREATE USER langfuse_user WITH PASSWORD 'langfuse_password';
GRANT ALL PRIVILEGES ON DATABASE langfuse TO langfuse_user;
\c langfuse
GRANT ALL ON SCHEMA public TO langfuse_user;

-- MLflow database
CREATE DATABASE mlflow;
CREATE USER mlflow_user WITH PASSWORD 'mlflow_password';
GRANT ALL PRIVILEGES ON DATABASE mlflow TO mlflow_user;
\c mlflow
GRANT ALL ON SCHEMA public TO mlflow_user;

-- Airflow database
CREATE DATABASE airflow;
CREATE USER airflow_user WITH PASSWORD 'airflow_password';
GRANT ALL PRIVILEGES ON DATABASE airflow TO airflow_user;
\c airflow
GRANT ALL ON SCHEMA public TO airflow_user;

-- Dagster database
CREATE DATABASE dagster;
CREATE USER dagster_user WITH PASSWORD 'dagster_password';
GRANT ALL PRIVILEGES ON DATABASE dagster TO dagster_user;
\c dagster
GRANT ALL ON SCHEMA public TO dagster_user;

-- report-portal database
CREATE DATABASE report_portal;
CREATE USER report_portal_user WITH PASSWORD 'report_portal_password';
GRANT ALL PRIVILEGES ON DATABASE report_portal TO report_portal_user;
\c report_portal
GRANT ALL ON SCHEMA public TO report_portal_user;

-- Chaos Mesh database
CREATE DATABASE chaos_mesh;
CREATE USER chaos_mesh_user WITH PASSWORD 'chaos_mesh_password';
GRANT ALL PRIVILEGES ON DATABASE chaos_mesh TO chaos_mesh_user;
\c chaos_mesh
GRANT ALL ON SCHEMA public TO chaos_mesh_user;

-- Superset database
CREATE DATABASE superset;
CREATE USER superset_user WITH PASSWORD 'superset_password';
GRANT ALL PRIVILEGES ON DATABASE superset TO superset_user;
\c superset
GRANT ALL ON SCHEMA public TO superset_user;

-- Paralus database
CREATE DATABASE paralus;
CREATE USER paralus_user WITH PASSWORD 'paralus_password';
GRANT ALL PRIVILEGES ON DATABASE paralus TO paralus_user;
\c paralus
GRANT ALL ON SCHEMA public TO paralus_user;

-- Harbor database
CREATE DATABASE harbor;
CREATE USER harbor_user WITH PASSWORD 'harbor_password';
GRANT ALL PRIVILEGES ON DATABASE harbor TO harbor_user;
\c harbor
GRANT ALL ON SCHEMA public TO harbor_user;

-- Uptrace database
CREATE DATABASE uptrace;
CREATE USER uptrace_user WITH PASSWORD 'uptrace_password';
GRANT ALL PRIVILEGES ON DATABASE uptrace TO uptrace_user;
\c uptrace
GRANT ALL ON SCHEMA public TO uptrace_user;
