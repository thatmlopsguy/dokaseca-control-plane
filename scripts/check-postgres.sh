#!/usr/bin/env bash
set -euo pipefail

# Check PostgreSQL databases, users, and permissions
# Usage: ./scripts/check-postgres.sh

CONTAINER="${POSTGRES_CONTAINER:-postgres}"
PG_USER="${PG_USER:-postgres}"

EXPECTED_DBS=(
  keycloak devlake temporal temporal_visibility backstage litellm langfuse
  mlflow airflow dagster report_portal chaos_mesh paralus
)

EXPECTED_USERS=(
  keycloak_user devlake_user temporal_user  backstage_user litellm_user langfuse_user
  mlflow_user airflow_user dagster_user report_portal_user chaos_mesh_user paralus_user
)

run_psql() {
  docker exec "${CONTAINER}" psql -U "${PG_USER}" -tAc "$1"
}

echo "=== PostgreSQL Health Check ==="
echo

# Check container is running
if ! docker inspect --format='{{.State.Running}}' "${CONTAINER}" 2>/dev/null | grep -q true; then
  echo "ERROR: Container '${CONTAINER}' is not running."
  exit 1
fi
echo "Container '${CONTAINER}' is running."
echo

# List and verify databases
echo "=== Databases ==="
existing_dbs=$(run_psql "SELECT datname FROM pg_database WHERE datistemplate = false ORDER BY datname;")
echo "${existing_dbs}"
echo

missing_dbs=()
for db in "${EXPECTED_DBS[@]}"; do
  if ! echo "${existing_dbs}" | grep -qx "${db}"; then
    missing_dbs+=("${db}")
  fi
done

if [[ ${#missing_dbs[@]} -gt 0 ]]; then
  echo "MISSING databases: ${missing_dbs[*]}"
else
  echo "All expected databases exist."
fi
echo

# List users (roles)
echo "=== Users (Roles) ==="
run_psql "SELECT rolname, rolsuper, rolcreatedb, rolcreaterole, rolcanlogin
  FROM pg_roles
  WHERE rolname NOT LIKE 'pg_%'
  ORDER BY rolname;" | column -t -s'|' -N "ROLE,SUPERUSER,CREATEDB,CREATEROLE,LOGIN"
echo

missing_users=()
existing_users=$(run_psql "SELECT rolname FROM pg_roles ORDER BY rolname;")
for user in "${EXPECTED_USERS[@]}"; do
  if ! echo "${existing_users}" | grep -qx "${user}"; then
    missing_users+=("${user}")
  fi
done

if [[ ${#missing_users[@]} -gt 0 ]]; then
  echo "MISSING users: ${missing_users[*]}"
else
  echo "All expected users exist."
fi
echo

# Check temporal_user has CREATEDB (required by Temporal admin-tools)
echo "=== temporal_user privileges ==="
temporal_createdb=$(run_psql "SELECT rolcreatedb FROM pg_roles WHERE rolname = 'temporal_user';") || true
if [[ -z "${temporal_createdb}" ]]; then
  echo "temporal_user not found or error querying role attributes."
else
  # psql returns 't' or 'f'
  if [[ "${temporal_createdb//[[:space:]]/}" != "t" ]]; then
    echo "WARNING: temporal_user does NOT have CREATEDB. This prevents Temporal init from creating databases."
    echo "Fix: docker exec ${CONTAINER} psql -U ${PG_USER} -c \"ALTER ROLE temporal_user CREATEDB;\""
  else
    echo "temporal_user has CREATEDB"
  fi
fi
echo

# Show database-level privileges
echo "=== Database Privileges ==="
for db in "${EXPECTED_DBS[@]}"; do
  if echo "${existing_dbs}" | grep -qx "${db}"; then
    grants=$(run_psql "SELECT grantee, privilege_type
      FROM information_schema.role_table_grants
      WHERE table_catalog = '${db}'
      LIMIT 5;" 2>/dev/null || true)
    acl=$(run_psql "SELECT datacl FROM pg_database WHERE datname = '${db}';")
    echo "${db}: ${acl:-<default>}"
  fi
done
echo

# Show schema-level privileges per database
echo "=== Schema Public Privileges ==="
for db in "${EXPECTED_DBS[@]}"; do
  if echo "${existing_dbs}" | grep -qx "${db}"; then
    schema_acl=$(docker exec "${CONTAINER}" psql -U "${PG_USER}" -d "${db}" -tAc \
      "SELECT nspacl FROM pg_namespace WHERE nspname = 'public';" 2>/dev/null || true)
    echo "${db}/public: ${schema_acl:-<default>}"
  fi
done
