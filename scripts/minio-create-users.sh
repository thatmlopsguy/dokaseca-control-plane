#!/usr/bin/env bash
set -euo pipefail

# Create a dedicated MinIO user per bucket with a read/write policy scoped to that bucket.
# Credentials are loaded from .env via direnv (see .envrc).
# Requires: mc (MinIO Client) -- https://min.io/docs/minio/linux/reference/minio-mc.html
#
# Usage:
#   ./scripts/minio-create-users.sh
#
# Environment variables (all optional):
#   MINIO_ENDPOINT       MinIO endpoint    (default: http://localhost:9000)
#   MC_ADMIN_USER        mc admin user     (default: minioAccessKey)
#   MC_ADMIN_PASSWORD    mc admin password (default: minioSecretKey)
#   MC_ALIAS             mc alias name     (default: local)

MINIO_ENDPOINT="${MINIO_ENDPOINT:-http://localhost:9000}"
MC_ADMIN_USER="${MC_ADMIN_USER:-minioAccessKey}"
MC_ADMIN_PASSWORD="${MC_ADMIN_PASSWORD:-minioSecretKey}"
MC_ALIAS="${MC_ALIAS:-local}"

# Buckets and their corresponding .env variable prefixes
# Format: bucket_name:ENV_PREFIX
BUCKETS=(
  velero:MINIO_VELERO
  loki:MINIO_LOKI
  tempo:MINIO_TEMPO
  pyroscope:MINIO_PYROSCOPE
  victoriametrics:MINIO_VICTORIA_METRICS
  victoriatraces:MINIO_VICTORIA_TRACES
  victorialogs:MINIO_VICTORIA_LOGS
  reportportal:MINIO_REPORT_PORTAL
  mlflow:MINIO_MLFLOW
  langfuse:MINIO_LANGFUSE
)

# ---------- helpers ----------------------------------------------------------

info()  { printf '[INFO]  %s\n' "$1"; }
error() { printf '[ERROR] %s\n' "$1" >&2; }

check_prerequisites() {
  if ! command -v mc &>/dev/null; then
    error "mc (MinIO Client) is not installed. Install it from https://min.io/docs/minio/linux/reference/minio-mc.html"
    exit 1
  fi
}

create_bucket_policy() {
  local bucket="$1"
  local policy_name="$2"

  local policy_json
  policy_json=$(cat <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject",
        "s3:ListBucket",
        "s3:GetBucketLocation"
      ],
      "Resource": [
        "arn:aws:s3:::${bucket}",
        "arn:aws:s3:::${bucket}/*"
      ]
    }
  ]
}
EOF
)

  local tmp_file
  tmp_file=$(mktemp)
  printf '%s' "${policy_json}" > "${tmp_file}"
  mc admin policy create "${MC_ALIAS}" "${policy_name}" "${tmp_file}"
  rm -f "${tmp_file}"
}

# ---------- main -------------------------------------------------------------

check_prerequisites

info "Configuring mc alias '${MC_ALIAS}' -> ${MINIO_ENDPOINT}"
mc alias set "${MC_ALIAS}" "${MINIO_ENDPOINT}" "${MC_ADMIN_USER}" "${MC_ADMIN_PASSWORD}" --api S3v4

printf '\n%-20s %-20s %s\n' "BUCKET" "USERNAME" "PASSWORD"
printf '%-20s %-20s %s\n' "------" "--------" "--------"

for entry in "${BUCKETS[@]}"; do
  bucket="${entry%%:*}"
  env_prefix="${entry##*:}"

  user_var="${env_prefix}_USER"
  pass_var="${env_prefix}_PASSWORD"
  username="${!user_var:-}"
  password="${!pass_var:-}"

  if [[ -z "${username}" || -z "${password}" ]]; then
    error "Missing ${user_var} or ${pass_var} in .env -- skipping bucket '${bucket}'"
    continue
  fi

  policy_name="${username}_policy"

  # Create policy scoped to this bucket
  create_bucket_policy "${bucket}" "${policy_name}" 2>/dev/null || true

  # Create (or update) the user
  if mc admin user info "${MC_ALIAS}" "${username}" &>/dev/null; then
    info "User '${username}' already exists -- updating"
  fi
  mc admin user add "${MC_ALIAS}" "${username}" "${password}"

  # Attach the policy to the user
  mc admin policy attach "${MC_ALIAS}" "${policy_name}" --user "${username}"

  printf '%-20s %-20s %s\n' "${bucket}" "${username}" "${password}"
done

printf '\nDone.\n'
