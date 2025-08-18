#!/bin/bash
# Deploy a Terraform environment
# This script automates the deployment of a Terraform environment
# It sets up the necessary workspaces and applies the Terraform configuration
# It also handles environment-specific variables and state management
#

set -e  # Exit on any error

if [[ $# -eq 0 ]] ; then
    echo "No arguments supplied"
    echo "Usage: deploy.sh <environment>"
    echo "Example: deploy.sh dev"
    exit 1
fi

env=$1

echo "Deploying $env with workspaces/${env}.tfvars ..."

# Check if the tfvars file exists
if [[ ! -f "workspaces/${env}.tfvars" ]]; then
    echo "Error: workspaces/${env}.tfvars does not exist"
    exit 1
fi

# Create workspace if it doesn't exist (ignore error if it already exists)
terraform workspace new $env 2>/dev/null || true
terraform workspace select $env
terraform init

echo "Applying terraform configuration..."
terraform apply -var-file="workspaces/${env}.tfvars" -auto-approve

# List all Kind clusters
echo "Current Kind clusters:"
kind get clusters
