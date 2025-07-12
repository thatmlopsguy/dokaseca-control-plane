#!/bin/bash

set -euo pipefail

# Source common functions and color variables
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
. "$SCRIPT_DIR/lib/common.sh"

# Default values
CLUSTER_NAME=""
FORCE=false
KUBECONFIG_DIR="kubeconfigs"

# Function to show usage
usage() {
    cat << EOF
Usage: $0 -c CLUSTER_NAME [OPTIONS]

Add a Kind cluster to ArgoCD with proper network configuration.

OPTIONS:
    -c, --cluster CLUSTER_NAME    Name of the Kind cluster to add (required)
    -f, --force                   Force re-add cluster even if it already exists
    -k, --kubeconfig-dir DIR      Directory to store kubeconfigs (default: kubeconfigs)
    -h, --help                    Show this help message

EXAMPLES:
    $0 -c workloads-dev
    $0 --cluster team-a-dev --force
    $0 -c workloads-prod -k /tmp/kubeconfigs

NOTES:
    - The script assumes you're running from the control-plane cluster context
    - Both clusters must be on the same Docker network (usually 'kind')
    - ArgoCD must be running and accessible via 'argocd' CLI

EOF
}

# Function to check prerequisites
check_prerequisites() {
    print_info "Checking prerequisites..."

    # Check if argocd CLI is available
    if ! command -v argocd &> /dev/null; then
        print_error "argocd CLI is not installed or not in PATH"
        print_info "Install it from: https://argo-cd.readthedocs.io/en/stable/cli_installation/"
        exit 1
    fi

    # Check if kind is available
    if ! command -v kind &> /dev/null; then
        print_error "kind is not installed or not in PATH"
        exit 1
    fi

    # Check if kubectl is available
    if ! command -v kubectl &> /dev/null; then
        print_error "kubectl is not installed or not in PATH"
        exit 1
    fi

    # Check if jq is available
    if ! command -v jq &> /dev/null; then
        print_error "jq is not installed or not in PATH"
        exit 1
    fi

    print_success "All prerequisites are available"
}

# Function to validate cluster exists
validate_cluster() {
    print_info "Validating cluster '$CLUSTER_NAME'..."

    if ! kind get clusters | grep -q "^${CLUSTER_NAME}$"; then
        print_error "Kind cluster '$CLUSTER_NAME' does not exist"
        print_info "Available clusters:"
        kind get clusters | sed 's/^/  - /'
        exit 1
    fi

    # Check if cluster is running
    if ! docker ps --format "table {{.Names}}" | grep -q "${CLUSTER_NAME}-control-plane"; then
        print_error "Cluster '$CLUSTER_NAME' is not running"
        exit 1
    fi

    print_success "Cluster '$CLUSTER_NAME' is running"
}

# Function to check if cluster is already in ArgoCD
check_existing_cluster() {
    print_info "Checking if cluster is already registered with ArgoCD..."

    if argocd cluster list -o json | jq -r '.[].name' | grep -q "^${CLUSTER_NAME}$"; then
        if [[ "$FORCE" == "false" ]]; then
            print_warning "Cluster '$CLUSTER_NAME' is already registered with ArgoCD"
            print_info "Use --force to re-add the cluster"
            exit 0
        else
            print_warning "Cluster '$CLUSTER_NAME' exists but will be re-added due to --force"
        fi
    fi
}

# Function to get cluster internal IP
get_cluster_ip() {
    local container_name="${CLUSTER_NAME}-control-plane"

    local ip
    ip=$(docker inspect "$container_name" | jq -r '.[0].NetworkSettings.Networks.kind.IPAddress')

    if [[ "$ip" == "null" || -z "$ip" ]]; then
        print_error "Could not get IP address for cluster '$CLUSTER_NAME'"
        exit 1
    fi

    echo "$ip"
}

# Function to create internal kubeconfig
create_internal_kubeconfig() {
    local cluster_ip="$1"
    local internal_kubeconfig="${KUBECONFIG_DIR}/${CLUSTER_NAME}-internal"

    print_info "Creating internal kubeconfig at '$internal_kubeconfig'..."

    # Create kubeconfig directory if it doesn't exist
    mkdir -p "$KUBECONFIG_DIR"

    # Clean up any existing file
    rm -f "$internal_kubeconfig"

    # Copy the existing working kubeconfig that we know works
    if [[ -f "${KUBECONFIG_DIR}/${CLUSTER_NAME}" ]]; then
        cp "${KUBECONFIG_DIR}/${CLUSTER_NAME}" "$internal_kubeconfig"
    else
        # Export kubeconfig with internal network settings
        if ! kind export kubeconfig --name "$CLUSTER_NAME" --internal --kubeconfig "$internal_kubeconfig"; then
            print_error "Failed to export kubeconfig for cluster '$CLUSTER_NAME'"
            exit 1
        fi
    fi

    # Create a temporary Python script to safely replace the server URL
    local temp_py
    temp_py=$(mktemp --suffix=.py)

    cat > "$temp_py" << 'PYEOF'
import yaml
import sys
import os

kubeconfig_file = sys.argv[1]
cluster_ip = sys.argv[2]

try:
    with open(kubeconfig_file, 'r') as f:
        config = yaml.safe_load(f)

    # Update the server URL
    for cluster in config.get('clusters', []):
        if 'cluster' in cluster and 'server' in cluster['cluster']:
            cluster['cluster']['server'] = f'https://{cluster_ip}:6443'

    with open(kubeconfig_file, 'w') as f:
        yaml.dump(config, f, default_flow_style=False)

    print("SUCCESS")
except Exception as e:
    print(f"ERROR: {e}")
    sys.exit(1)
PYEOF

    if ! python3 "$temp_py" "$internal_kubeconfig" "$cluster_ip"; then
        print_error "Failed to update kubeconfig server address"
        rm -f "$temp_py"
        exit 1
    fi

    rm -f "$temp_py"

    # Verify the kubeconfig is valid
    if ! kubectl config view --kubeconfig "$internal_kubeconfig" > /dev/null 2>&1; then
        print_error "Generated kubeconfig is invalid"
        exit 1
    fi

    print_success "Internal kubeconfig created successfully"
}

# Function to add cluster to ArgoCD
add_cluster_to_argocd() {
    local internal_kubeconfig="$1"

    print_info "Adding cluster '$CLUSTER_NAME' to ArgoCD..."

    # Get the actual context name from the kubeconfig
    local context_name
    context_name=$(kubectl config get-contexts --kubeconfig "$internal_kubeconfig" -o name 2>/dev/null | head -1)

    if [[ -z "$context_name" ]]; then
        print_error "Could not determine context name from kubeconfig"
        exit 1
    fi

    print_info "Using context: $context_name"

    # Prepare argocd command with optional upsert flag
    local argocd_cmd="argocd cluster add --kubeconfig $internal_kubeconfig --name $CLUSTER_NAME"
    if [[ "$FORCE" == "true" ]]; then
        argocd_cmd="$argocd_cmd --upsert"
    fi
    argocd_cmd="$argocd_cmd $context_name"

    # Add cluster to ArgoCD
    if eval "$argocd_cmd"; then
        print_success "Cluster '$CLUSTER_NAME' successfully added to ArgoCD"
    else
        print_error "Failed to add cluster '$CLUSTER_NAME' to ArgoCD"
        exit 1
    fi
}

# Function to verify cluster was added
verify_cluster() {
    print_info "Verifying cluster registration..."

    if argocd cluster list | grep -q "$CLUSTER_NAME"; then
        print_success "Cluster '$CLUSTER_NAME' is now registered with ArgoCD"
        echo
        print_info "Current ArgoCD clusters:"
        argocd cluster list
    else
        print_error "Cluster verification failed"
        exit 1
    fi
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -c|--cluster)
            CLUSTER_NAME="$2"
            shift 2
            ;;
        -f|--force)
            FORCE=true
            shift
            ;;
        -k|--kubeconfig-dir)
            KUBECONFIG_DIR="$2"
            shift 2
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            print_error "Unknown option: $1"
            usage
            exit 1
            ;;
    esac
done

# Validate required arguments
if [[ -z "$CLUSTER_NAME" ]]; then
    print_error "Cluster name is required"
    usage
    exit 1
fi

# Main execution
main() {
    print_info "Starting ArgoCD cluster addition process..."
    print_info "Cluster Name: $CLUSTER_NAME"
    check_prerequisites
    validate_cluster
    check_existing_cluster

    print_info "Getting internal IP for cluster '$CLUSTER_NAME'..."
    cluster_ip=$(get_cluster_ip)
    print_success "Cluster IP: $cluster_ip"

    create_internal_kubeconfig "$cluster_ip"
    internal_kubeconfig="${KUBECONFIG_DIR}/${CLUSTER_NAME}-internal"

    add_cluster_to_argocd "$internal_kubeconfig"
    verify_cluster

    print_success "Cluster '$CLUSTER_NAME' has been successfully added to ArgoCD!"
    print_info "You can now deploy applications to this cluster using ArgoCD"
}

# Run main function
main
