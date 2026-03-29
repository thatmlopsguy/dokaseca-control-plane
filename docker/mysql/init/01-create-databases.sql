-- Create databases and users for platform services
-- This script runs automatically when the MySQL container starts for the first time.
-- Files in /docker-entrypoint-initdb.d/ execute in alphabetical order.

-- DevLake database (default, also created via MYSQL_DATABASE env var)
CREATE DATABASE IF NOT EXISTS devlake;
CREATE USER IF NOT EXISTS 'devlake_user'@'%' IDENTIFIED BY 'devlake_password';
GRANT ALL PRIVILEGES ON devlake.* TO 'devlake_user'@'%';

FLUSH PRIVILEGES;
