-- Create databases for platform services
-- This script runs automatically when the ClickHouse container starts.

CREATE DATABASE IF NOT EXISTS langfuse;
CREATE DATABASE IF NOT EXISTS signoz;
CREATE DATABASE IF NOT EXISTS uptrace;

CREATE USER IF NOT EXISTS langfuse_user IDENTIFIED WITH plaintext_password BY 'langfuse_password';
CREATE USER IF NOT EXISTS signoz_user IDENTIFIED WITH plaintext_password BY 'signoz_password';
CREATE USER IF NOT EXISTS uptrace_user IDENTIFIED WITH plaintext_password BY 'uptrace_password';

GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, ALTER ON langfuse.* TO langfuse_user;
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, ALTER ON signoz.* TO signoz_user;
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, ALTER ON uptrace.* TO uptrace_user;

-- Grant global CLUSTER privilege required for distributed DDL
GRANT CLUSTER ON *.* TO langfuse_user;
GRANT CLUSTER ON *.* TO signoz_user;
GRANT CLUSTER ON *.* TO uptrace_user;
