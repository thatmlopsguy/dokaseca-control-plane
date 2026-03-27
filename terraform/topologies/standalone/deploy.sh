#!/bin/bash
# This script deploys the standalone topology using Terraform. It initializes the Terraform configuration,
# applies it, and then lists the created Kind clusters, vclusters, and ArgoCD Applications.
#
set -e  # Exit on any error

PROJECT_ROOT=$(git rev-parse --show-toplevel)

source "$PROJECT_ROOT/scripts/lib/common.sh"

# Check prerequisites before proceeding
check_prerequisites

terraform init -upgrade

print_header "Applying terraform configuration"
terraform apply -auto-approve

# List all Kind clusters
print_header "Current Kind clusters"
kind get clusters 2>/dev/null || echo "No Kind clusters found"

# List all vclusters
print_header "Current vclusters"
vcluster list 2>/dev/null || echo "No vclusters found"

verify_deployment

print_next_steps
