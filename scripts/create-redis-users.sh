#!/usr/bin/env bash
# Create dedicated Redis ACL users for platform services.
# Usage: ./scripts/create-redis-users.sh
#
# Optional environment variables:
#   REDIS_CONTAINER        Redis container name (default: redis)
#   REDIS_ADMIN_USER       Redis admin user for ACL commands (default: default)
#   REDIS_PASSWORD         Redis admin password (auto-detected from container env if unset)
#
# Service credential overrides:
#   REDIS_LANGFUSE_USER / REDIS_LANGFUSE_PASSWORD
#   REDIS_LITELLM_USER / REDIS_LITELLM_PASSWORD
#   REDIS_AIRFLOW_USER / REDIS_AIRFLOW_PASSWORD
#   REDIS_DAGSTER_USER / REDIS_DAGSTER_PASSWORD
#   REDIS_SUPERSET_USER / REDIS_SUPERSET_PASSWORD
#   REDIS_HARBOR_USER / REDIS_HARBOR_PASSWORD
#   REDIS_UPTRACE_USER / REDIS_UPTRACE_PASSWORD
set -euo pipefail

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load common functions
# shellcheck source=lib/common.sh
source "$SCRIPT_DIR/lib/common.sh"

REDIS_CONTAINER="${REDIS_CONTAINER:-redis}"
REDIS_ADMIN_USER="${REDIS_ADMIN_USER:-default}"
REDIS_PASSWORD="${REDIS_PASSWORD:-}"

# Format: service:ENV_PREFIX
SERVICES=(
  langfuse:REDIS_LANGFUSE
  litellm:REDIS_LITELLM
  airflow:REDIS_AIRFLOW
  dagster:REDIS_DAGSTER
  superset:REDIS_SUPERSET
  harbor:REDIS_HARBOR
  uptrace:REDIS_UPTRACE
)

redis_exec() {
  if [[ -n "${REDIS_PASSWORD}" ]]; then
    docker exec "${REDIS_CONTAINER}" redis-cli --no-auth-warning --user "${REDIS_ADMIN_USER}" -a "${REDIS_PASSWORD}" "$@"
  else
    docker exec "${REDIS_CONTAINER}" redis-cli --user "${REDIS_ADMIN_USER}" "$@"
  fi
}

check_prerequisites() {
  if ! command -v docker >/dev/null 2>&1; then
    print_error "docker is required but not installed."
    exit 1
  fi

  if ! docker inspect --format='{{.State.Running}}' "${REDIS_CONTAINER}" 2>/dev/null | grep -q true; then
    print_error "Container '${REDIS_CONTAINER}' is not running."
    exit 1
  fi
}

autodetect_admin_password() {
  if [[ -n "${REDIS_PASSWORD}" ]]; then
    return
  fi

  REDIS_PASSWORD=$(docker inspect --format='{{range .Config.Env}}{{println .}}{{end}}' "${REDIS_CONTAINER}" \
    | awk -F= '$1=="REDIS_PASSWORD" {print $2}' \
    | tail -n1)
}

main() {
  check_prerequisites
  autodetect_admin_password

  if [[ -n "${REDIS_PASSWORD}" ]]; then
    print_info "Using password authentication for Redis admin user '${REDIS_ADMIN_USER}'."
  else
    print_info "REDIS_PASSWORD is unset; trying passwordless auth for Redis admin user '${REDIS_ADMIN_USER}'."
  fi

  # Validate we can connect before applying ACL changes.
  redis_exec PING >/dev/null

  printf '\n%-12s %-20s %s\n' "SERVICE" "USERNAME" "PASSWORD"
  printf '%-12s %-20s %s\n' "-------" "--------" "--------"

  for entry in "${SERVICES[@]}"; do
    service="${entry%%:*}"
    env_prefix="${entry##*:}"

    user_var="${env_prefix}_USER"
    pass_var="${env_prefix}_PASSWORD"

    username="${!user_var:-${service}_user}"
    password="${!pass_var:-${service}_password}"

    # Create/update ACL user with broad command and key permissions.
    redis_exec ACL SETUSER "${username}" on ">${password}" "~*" "+@all" >/dev/null
    printf '%-12s %-20s %s\n' "${service}" "${username}" "${password}"
  done

  print_success 'Done.'
}

main "$@"
