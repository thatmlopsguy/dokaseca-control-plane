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
	echo -e "${GREEN}[OK]${NC} $1"
}

print_warning() {
	echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
	echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo ""
    echo -e "${CYAN}==================================================${NC}"
    echo -e "${CYAN}$1${NC}"
    echo -e "${CYAN}==================================================${NC}"
}

# Function to get version command output
get_version() {
    local tool="$1"
    local cmd="$2"

    if command -v "$tool" &>/dev/null; then
        local version_output
        if version_output=$(eval "$cmd" 2>/dev/null); then
            echo "$version_output" | head -1
        else
            echo "Installed (version check failed)"
        fi
    else
        echo "NOT INSTALLED"
    fi
}

wait_for_pods_ready() {
    local timeout=${1:-300}
    local interval=${2:-15}
    local elapsed=0

    print_header "Waiting for Pods to be Ready"
    print_info "Timeout: ${timeout}s, checking every ${interval}s"
    sleep 5  # Give pods time to start

    while [[ $elapsed -lt $timeout ]]; do
        local total
        total=$(kubectl get pods --all-namespaces --no-headers 2>/dev/null | wc -l | tr -d ' ')
        local running
        running=$(kubectl get pods --all-namespaces --field-selector=status.phase=Running --no-headers 2>/dev/null | wc -l | tr -d ' ')

        if [[ "$total" -eq 0 ]]; then
            print_info "No pods found yet (${elapsed}s elapsed)"
        elif [[ "$running" -eq "$total" ]]; then
            print_success "All $total pods are running"
            return 0
        else
            print_info "Progress: $running/$total pods running (${elapsed}s elapsed)"
        fi

        sleep $interval
        elapsed=$((elapsed + interval))
    done

    print_error "Timeout after ${timeout}s"
    kubectl get pods --all-namespaces
    return 1
}

# Check prerequisites
check_prerequisites() {
    print_info "Checking prerequisites..."

    command -v terraform >/dev/null 2>&1 || { print_error "terraform is required but not installed."; exit 1; }
    command -v kubectl >/dev/null 2>&1 || { print_error "kubectl is required but not installed."; exit 1; }
    command -v kind >/dev/null 2>&1 || { print_error "kind is required but not installed."; exit 1; }

    print_success "Prerequisites check passed"
}

verify_deployment() {
    print_info "Verifying deployment..."

    print_header "Kubernetes nodes"
    kubectl get nodes

    print_header "Kubernetes namespaces"
    kubectl get namespaces

    print_header "ArgoCD Applications"
    kubectl get applications -n argocd
}

print_next_steps() {
    print_header "Next Steps"
    echo "1. Port-forward ArgoCD:"
    echo "   kubectl port-forward svc/argo-cd-argocd-server -n argocd 8088:443"
    echo ""
    echo "2. Access ArgoCD UI at https://localhost:8088"
    echo "   Username: admin"
    echo "   Password: $(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode)"
    echo ""
    print_header "Monitor Application Sync Status"
    echo "   kubectl get applications -n argocd"
    echo ""
    print_header "Clean Up (when done)"
    echo "   make clean-infra"
}
