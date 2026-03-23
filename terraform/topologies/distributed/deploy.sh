#!/bin/bash
# Deploy a Terraform environment
# This script automates the deployment of a Terraform environment
# It sets up the necessary workspaces and applies the Terraform configuration
# It also handles environment-specific variables and state management
#

set -e  # Exit on any error

PROJECT_ROOT=$(git rev-parse --show-toplevel)

source "$PROJECT_ROOT/scripts/lib/common.sh"

# Check prerequisites before proceeding
check_prerequisites

if [[ $# -eq 0 ]] ; then
    print_error "No arguments supplied"
    print_info "Usage: deploy.sh <environment>"
    print_info "Example: deploy.sh dev"
    exit 1
fi

env=$1

check_prerequisites

print_header "Deploying $env with workspaces/${env}.tfvars ..."
terraform init -upgrade

# Check if the tfvars file exists
if [[ ! -f "workspaces/${env}.tfvars" ]]; then
    print_error "workspaces/${env}.tfvars does not exist"
    exit 1
fi

# Create workspace if it doesn't exist (ignore error if it already exists)
terraform workspace new $env 2>/dev/null || true
terraform workspace select $env

print_header "Applying terraform configuration..."
terraform apply -var-file="workspaces/${env}.tfvars" -auto-approve

# List all Kind clusters
print_header "Current Kind clusters"
kind get clusters 2>/dev/null || echo "No Kind clusters found"

# List all vclusters
print_header "Current vclusters"
vcluster list 2>/dev/null || echo "No vclusters found"

verify_deployment
