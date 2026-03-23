#!/bin/bash
# This script deploys the standalone topology using Terraform. It initializes the Terraform configuration,
# applies it, and then lists the created Kind clusters, vclusters, and ArgoCD Applications.
#
set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check prerequisites
check_prerequisites() {
    print_status "Checking prerequisites..."

    command -v terraform >/dev/null 2>&1 || { print_error "terraform is required but not installed."; exit 1; }
    command -v kubectl >/dev/null 2>&1 || { print_error "kubectl is required but not installed."; exit 1; }
    command -v kind >/dev/null 2>&1 || { print_error "kind is required but not installed."; exit 1; }
    command -v vcluster >/dev/null 2>&1 || { print_error "vcluster is required but not installed."; exit 1; }

    print_status "Prerequisites check passed"
}


terraform init -upgrade

echo "Applying terraform configuration..."
terraform apply -auto-approve

# List all Kind clusters
echo "Current Kind clusters:"
kind get clusters 2>/dev/null || echo "No Kind clusters found"

# List all vclusters
echo "Current vclusters:"
vcluster list 2>/dev/null || echo "No vclusters found"

# List all Kubernetes nodes
echo "Kubernetes nodes in the current context:"
kubectl get nodes

# List all ArgoCD Applications
echo "ArgoCD Applications:"
kubectl get applications -n argocd
