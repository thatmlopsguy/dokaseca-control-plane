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
