#!/bin/bash

set -e  # Exit on any error

terraform init -upgrade

echo "Applying terraform configuration..."
terraform apply -auto-approve

# List all Kind clusters
echo "Current Kind cluster:"
kind get clusters
