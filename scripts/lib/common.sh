#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
	echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
	echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
	echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
	echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${PURPLE}=== $1 ===${NC}"
}

verify_deployment() {

    print_info "Verifying deployment..."

    print_header "Kubernetes nodes"
    kubectl get nodes

    print_header "ArgoCD Applications"
    kubectl get applications -n argocd
}

print_next_steps() {

    print_header "Next Steps"
    echo "1. Port-forward ArgoCD:"
    echo "   kubectl port-forward svc/argocd-server -n argocd 8080:443"
    echo ""
    echo "2. Access ArgoCD UI at https://localhost:8080"
    echo "   Username: admin"
    echo "   Password: $ARGOCD_PASSWORD"
    echo ""
    print_header "Monitor Application Sync Status"
    echo "   kubectl get applications -n argocd"
    echo ""
    print_header "Clean Up (when done)"
    echo "   make clean-infra"
}
