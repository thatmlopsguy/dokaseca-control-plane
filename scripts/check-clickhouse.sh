#!/usr/bin/env bash
# Check ClickHouse databases, users, and permissions
# Usage: ./scripts/check-clickhouse.sh

set -euo pipefail

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load common functions
# shellcheck source=lib/common.sh
source "$SCRIPT_DIR/lib/common.sh"

CONTAINER="${CLICKHOUSE_CONTAINER:-clickhouse}"
CLICKHOUSE_USER="${CLICKHOUSE_USER:-default}"
CLICKHOUSE_PASSWORD="${CLICKHOUSE_PASSWORD:-}"

EXPECTED_DBS=(
  langfuse signoz uptrace
)

EXPECTED_USERS=(
  langfuse_user signoz_user uptrace_user
)

EXPECTED_ACCESS_TYPES=(
  SELECT INSERT ALTER
)

run_clickhouse() {
  if [[ -n "${CLICKHOUSE_PASSWORD}" ]]; then
    docker exec "${CONTAINER}" clickhouse-client \
      --user "${CLICKHOUSE_USER}" \
      --password "${CLICKHOUSE_PASSWORD}" \
      --query "$1"
  else
    docker exec "${CONTAINER}" clickhouse-client \
      --user "${CLICKHOUSE_USER}" \
      --query "$1"
  fi
}

print_info "ClickHouse Health Check"
# Check container is running
if ! docker inspect --format='{{.State.Running}}' "${CONTAINER}" 2>/dev/null | grep -q true; then
  print_error "Container '${CONTAINER}' is not running."
  exit 1
fi
print_info "Container '${CONTAINER}' is running."

if [[ -z "${CLICKHOUSE_PASSWORD}" ]]; then
  CLICKHOUSE_PASSWORD=$(docker inspect --format='{{range .Config.Env}}{{println .}}{{end}}' "${CONTAINER}" \
    | awk -F= '$1=="CLICKHOUSE_PASSWORD" {print $2}' \
    | tail -n1)
fi

if [[ -z "${CLICKHOUSE_PASSWORD}" ]]; then
  print_info "CLICKHOUSE_PASSWORD not set. Trying passwordless auth for user '${CLICKHOUSE_USER}'."
else
  print_info "Using password authentication for user '${CLICKHOUSE_USER}'."
fi

# List and verify databases
print_info "Databases"
existing_dbs=$(run_clickhouse "SELECT name FROM system.databases ORDER BY name")
echo "${existing_dbs}"

missing_dbs=()
for db in "${EXPECTED_DBS[@]}"; do
  if ! echo "${existing_dbs}" | grep -qx "${db}"; then
    missing_dbs+=("${db}")
  fi
done

if [[ ${#missing_dbs[@]} -gt 0 ]]; then
  print_error "MISSING databases: ${missing_dbs[*]}"
else
  print_info "All expected databases exist."
fi

# List and verify users
print_info "Users"
existing_users=$(run_clickhouse "SELECT name FROM system.users ORDER BY name")
echo "${existing_users}"

missing_users=()
for user in "${EXPECTED_USERS[@]}"; do
  if ! echo "${existing_users}" | grep -qx "${user}"; then
    missing_users+=("${user}")
  fi
done

if [[ ${#missing_users[@]} -gt 0 ]]; then
  print_error "MISSING users: ${missing_users[*]}"
else
  print_info "All expected users exist."
fi

# Show and verify grants
print_info "Grants"
existing_grants=$(run_clickhouse "SELECT user_name, access_type, database FROM system.grants WHERE user_name IN ('langfuse_user', 'signoz_user', 'uptrace_user') ORDER BY user_name, database, access_type")
echo "${existing_grants}"

missing_grants=()
for db in "${EXPECTED_DBS[@]}"; do
  user="${db}_user"
  for access_type in "${EXPECTED_ACCESS_TYPES[@]}"; do
    if ! echo "${existing_grants}" | awk '{print $1" "$2" "$3}' | grep -qx "${user} ${access_type} ${db}"; then
      missing_grants+=("${user}:${access_type}:${db}")
    fi
  done
done

if [[ ${#missing_grants[@]} -gt 0 ]]; then
  print_error "MISSING grants: ${missing_grants[*]}"
else
  print_info "All expected grants exist."
fi
