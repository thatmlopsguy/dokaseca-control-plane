-- Create databases and users for platform services
-- This script runs automatically when the PostgreSQL container starts

-- Keycloak database
CREATE DATABASE keycloak;
CREATE USER keycloak WITH PASSWORD 'keycloak_password';
GRANT ALL PRIVILEGES ON DATABASE keycloak TO keycloak;
\c keycloak
GRANT ALL ON SCHEMA public TO keycloak;

-- DevLake database
CREATE DATABASE devlake;
CREATE USER devlake WITH PASSWORD 'devlake_password';
GRANT ALL PRIVILEGES ON DATABASE devlake TO devlake;
\c devlake
GRANT ALL ON SCHEMA public TO devlake;

-- Temporal database
CREATE DATABASE temporal;
CREATE USER temporal WITH PASSWORD 'temporal_password';
GRANT ALL PRIVILEGES ON DATABASE temporal TO temporal;
\c temporal
GRANT ALL ON SCHEMA public TO temporal;

-- Backstage database
CREATE DATABASE backstage;
CREATE USER backstage WITH PASSWORD 'backstage_password';
GRANT ALL PRIVILEGES ON DATABASE backstage TO backstage;
\c backstage
GRANT ALL ON SCHEMA public TO backstage;

-- LiteLLM database
CREATE DATABASE litellm;
CREATE USER litellm WITH PASSWORD 'litellm_password';
GRANT ALL PRIVILEGES ON DATABASE litellm TO litellm;
\c litellm
GRANT ALL ON SCHEMA public TO litellm;

-- Langfuse database
CREATE DATABASE langfuse;
CREATE USER langfuse WITH PASSWORD 'langfuse_password';
GRANT ALL PRIVILEGES ON DATABASE langfuse TO langfuse;
\c langfuse
GRANT ALL ON SCHEMA public TO langfuse;

-- MLflow database
CREATE DATABASE mlflow;
CREATE USER mlflow WITH PASSWORD 'mlflow_password';
GRANT ALL PRIVILEGES ON DATABASE mlflow TO mlflow;
\c mlflow
GRANT ALL ON SCHEMA public TO mlflow;

-- Airflow database
CREATE DATABASE airflow;
CREATE USER airflow WITH PASSWORD 'airflow_password';
GRANT ALL PRIVILEGES ON DATABASE airflow TO airflow;
\c airflow
GRANT ALL ON SCHEMA public TO airflow;

-- Dagster database
CREATE DATABASE dagster;
CREATE USER dagster WITH PASSWORD 'dagster_password';
GRANT ALL PRIVILEGES ON DATABASE dagster TO dagster;
\c dagster
GRANT ALL ON SCHEMA public TO dagster;

-- report-portal database
CREATE DATABASE report_portal;
CREATE USER report_portal WITH PASSWORD 'report_portal_password';
GRANT ALL PRIVILEGES ON DATABASE report_portal TO report_portal;
\c report_portal
GRANT ALL ON SCHEMA public TO report_portal;

-- Chaos Mesh database
CREATE DATABASE chaos_mesh;
CREATE USER chaos_mesh WITH PASSWORD 'chaos_mesh_password';
GRANT ALL PRIVILEGES ON DATABASE chaos_mesh TO chaos_mesh;
\c chaos_mesh
GRANT ALL ON SCHEMA public TO chaos_mesh;

-- Paralus database
CREATE DATABASE paralus;
CREATE USER paralus WITH PASSWORD 'paralus_password';
GRANT ALL PRIVILEGES ON DATABASE paralus TO paralus;
\c paralus
GRANT ALL ON SCHEMA public TO paralus;
