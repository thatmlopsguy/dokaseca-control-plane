#!/bin/bash

set -e  # Exit on any error

terraform init -upgrade

echo "Applying terraform configuration..."
terraform apply -auto-approve

# List all Kind clusters
echo "Current Kind clusters:"
kind get clusters 2>/dev/null || echo "No Kind clusters found"

# List all vclusters
echo "Current vclusters:"
vcluster list 2>/dev/null || echo "No vclusters found"
