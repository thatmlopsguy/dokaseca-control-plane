#!/bin/bash

# SBOM (Software Bill of Materials) Generator for Doka Seca
# This script generates/updates the sbom.txt with all the tools required to run this project

set -euo pipefail

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
SBOM_FILE="$PROJECT_DIR/sbom.txt"
VERSION_FILE="$PROJECT_DIR/VERSION"

# Load common functions
# shellcheck source=lib/common.sh
source "$SCRIPT_DIR/lib/common.sh"

# Alias for consistency with existing code
print_status() {
    print_info "$1"
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

# Function to generate SBOM header
generate_sbom_header() {
    local project_version="unknown"
    if [[ -f "$VERSION_FILE" ]]; then
        project_version=$(cat "$VERSION_FILE" | tr -d '[:space:]')
    fi

    cat << EOF
# Software Bill of Materials (SBOM) for Doka Seca - Distributed Orchestration Kubernetes Automation with Scalable Edge Computing Applications
# Version: $project_version
# Generated on: $(date -u '+%Y-%m-%d %H:%M:%S UTC')
# Project: DoKa Seca - Distributed Orchestration Kubernetes Automation with Scalable Edge Computing Applications
# Repository: https://github.com/thatmlopsguy/dokaseca-control-plane
# License: Apache License 2.0

## Description

This SBOM lists all the tools, dependencies, and components required to run the
Doka Seca project. This includes core Kubernetes tools, infrastructure as code
tools, GitOps tools, observability stack components, security tools, and development
dependencies.

The project provides a comprehensive framework for bootstrapping cloud-native
platforms using Kubernetes in Docker (Kind), including GitOps workflows,
infrastructure as code, observability stacks, and cloud-native security practices.

EOF
}

# Main SBOM generation function
generate_sbom() {
    print_header "Generating SBOM for Doka Seca - Distributed Orchestration Kubernetes Automation with Scalable Edge Computing Applications"

    # Create or overwrite SBOM file
    generate_sbom_header > "$SBOM_FILE"

    # Core System Tools
    print_status "Analyzing core system tools..."
    cat << 'EOF' >> "$SBOM_FILE"

## 1. Core System Requirements

### Essential Unix Tools
- bash >= 4.0 (shell scripting)
- curl (HTTP client for downloads)
- base64 (encoding/decoding utility)
- jq (JSON processor)
- git (version control)

### System Dependencies
EOF

    declare -A core_tools=(
        [bash]="bash --version | head -1"
        [curl]="curl --version | head -1"
        [base64]="base64 --version | head -1"
        [jq]="jq --version"
        [git]="git --version"
    )

    for tool in "${!core_tools[@]}"; do
        local version
        version=$(get_version "$tool" "${core_tools[$tool]}")
        echo "- $tool: $version" >> "$SBOM_FILE"
    done

    # Container Runtime and Orchestration
    print_status "Analyzing container and Kubernetes tools..."
    cat << 'EOF' >> "$SBOM_FILE"

## 2. Container Runtime & Kubernetes Tools

### Container Platform
EOF

    declare -A container_tools=(
        [docker]="docker --version"
        [podman]="podman --version"
    )

    for tool in "${!container_tools[@]}"; do
        local version
        version=$(get_version "$tool" "${container_tools[$tool]}")
        echo "- $tool: $version" >> "$SBOM_FILE"
    done

    cat << 'EOF' >> "$SBOM_FILE"

### Kubernetes Distribution Tools
EOF

    declare -A k8s_distro_tools=(
        [kind]="kind version | awk '{print \$2}'"
        [k3d]="k3d version | awk 'NR==1 {print \$3}'"
        [k0s]="k0s version"
    )

    for tool in "${!k8s_distro_tools[@]}"; do
        local version
        version=$(get_version "$tool" "${k8s_distro_tools[$tool]}")
        echo "- $tool: $version" >> "$SBOM_FILE"
    done

    cat << 'EOF' >> "$SBOM_FILE"

### Kubernetes Client Tools
EOF

    declare -A k8s_client_tools=(
        [kubectl]="kubectl version --client --output=yaml | grep gitVersion | awk '{print \$2}'"
        [helm]="helm version --short"
        [kustomize]="kustomize version"
    )

    for tool in "${!k8s_client_tools[@]}"; do
        local version
        version=$(get_version "$tool" "${k8s_client_tools[$tool]}")
        echo "- $tool: $version" >> "$SBOM_FILE"
    done

    # Infrastructure as Code
    print_status "Analyzing Infrastructure as Code tools..."
    cat << 'EOF' >> "$SBOM_FILE"

## 3. Infrastructure as Code (IaC)

### Terraform/OpenTofu
EOF

    declare -A iac_tools=(
        [terraform]="terraform --version | awk 'NR==1 {print \$2}'"
        [tofu]="tofu --version | awk 'NR==1 {print \$2}'"
    )

    for tool in "${!iac_tools[@]}"; do
        local version
        version=$(get_version "$tool" "${iac_tools[$tool]}")
        echo "- $tool: $version" >> "$SBOM_FILE"
    done

    # GitOps and Deployment Tools
    print_status "Analyzing GitOps and deployment tools..."
    cat << 'EOF' >> "$SBOM_FILE"

## 4. GitOps & Deployment Tools

### ArgoCD Ecosystem
EOF

    declare -A gitops_tools=(
        [argocd]="argocd version --client | awk 'NR==1 {print \$2}'"
        [kargo]="kargo version | awk 'NR==1 {print \$3}'"
    )

    for tool in "${!gitops_tools[@]}"; do
        local version
        version=$(get_version "$tool" "${gitops_tools[$tool]}")
        echo "- $tool: $version" >> "$SBOM_FILE"
    done

    cat << 'EOF' >> "$SBOM_FILE"

### FluxCD Tools
EOF

    declare -A flux_tools=(
        [flux]="flux -v | awk '{print \$3}'"
    )

    for tool in "${!flux_tools[@]}"; do
        local version
        version=$(get_version "$tool" "${flux_tools[$tool]}")
        echo "- $tool: $version" >> "$SBOM_FILE"
    done

    cat << 'EOF' >> "$SBOM_FILE"

### Cluster Management
EOF

    declare -A cluster_mgmt_tools=(
        [clusterctl]="clusterctl version -o short"
        [vcluster]="vcluster --version | awk '{print \$3}'"
    )

    for tool in "${!cluster_mgmt_tools[@]}"; do
        local version
        version=$(get_version "$tool" "${cluster_mgmt_tools[$tool]}")
        echo "- $tool: $version" >> "$SBOM_FILE"
    done

    # Security Tools
    print_status "Analyzing security tools..."
    cat << 'EOF' >> "$SBOM_FILE"

## 5. Security Tools

### Image Signing & Vulnerability Scanning
EOF

    declare -A security_tools=(
        [cosign]="cosign version | grep GitVersion | cut -d':' -f2 | tr -d ' '"
        [trivy]="trivy --version | awk 'NR==1 {print \$2}'"
        [falcoctl]="falcoctl version | awk '{print \$3}'"
        [gitleaks]="gitleaks --version | awk 'NR==1 {print \$3}'"
    )

    for tool in "${!security_tools[@]}"; do
        local version
        version=$(get_version "$tool" "${security_tools[$tool]}")
        echo "- $tool: $version" >> "$SBOM_FILE"
    done

    cat << 'EOF' >> "$SBOM_FILE"

### Certificate Management
EOF

    declare -A cert_tools=(
        [mkcert]="mkcert -version"
        [openssl]="openssl version"
    )

    for tool in "${!cert_tools[@]}"; do
        local version
        version=$(get_version "$tool" "${cert_tools[$tool]}")
        echo "- $tool: $version" >> "$SBOM_FILE"
    done

    # Backup and Storage Tools
    print_status "Analyzing backup and storage tools..."
    cat << 'EOF' >> "$SBOM_FILE"

## 6. Backup & Storage Tools

### Backup Solutions
EOF

    declare -A backup_tools=(
        [velero]="velero version --client-only | awk 'NR==2 {print \$2}'"
        [mc]="mc --version | awk 'NR==1 {print \$3}'"
        [vault]="vault version | awk 'NR==1 {print \$2}' | tr -d ','"
    )

    for tool in "${!backup_tools[@]}"; do
        local version
        version=$(get_version "$tool" "${backup_tools[$tool]}")
        echo "- $tool: $version" >> "$SBOM_FILE"
    done

    # Network Tools
    print_status "Analyzing network tools..."
    cat << 'EOF' >> "$SBOM_FILE"

## 7. Network & Service Mesh Tools

### Service Mesh
EOF

    declare -A network_tools=(
        [istioctl]="istioctl version --short --remote=false | awk 'NR==1 {print \$3}'"
        [cilium]="cilium version --client | awk '{print \$2}'"
        [hubble]="hubble version | awk '{print \$2}' | cut -d'@' -f1"
    )

    for tool in "${!network_tools[@]}"; do
        local version
        version=$(get_version "$tool" "${network_tools[$tool]}")
        echo "- $tool: $version" >> "$SBOM_FILE"
    done

    # Observability and Monitoring
    print_status "Analyzing observability tools..."
    cat << 'EOF' >> "$SBOM_FILE"

## 8. Observability & Monitoring Tools

### Kubernetes Dashboards
EOF

    declare -A observability_tools=(
        [k9s]="k9s version | grep Version | cut -d':' -f2 | tr -d '[:space:]' | sed 's/\x1b\[[0-9;]*m//g'"
        [flux9s]="flux9s version | grep Version | cut -d':' -f2"
    )

    for tool in "${!observability_tools[@]}"; do
        local version
        version=$(get_version "$tool" "${observability_tools[$tool]}")
        echo "- $tool: $version" >> "$SBOM_FILE"
    done

    # Development Tools
    print_status "Analyzing development tools..."
    cat << 'EOF' >> "$SBOM_FILE"

## 9. Development Tools

### Build Tools
EOF

    declare -A dev_tools=(
        [make]="make --version | awk 'NR==1 {print \$3}'"
        [just]="just --version | awk '{print \$2}'"
        [mise]="mise --version | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+'"
        [go]="go version | awk '{print \$3}'"
        [python]="uv run python --version | awk '{print \$2}'"
        [node]="node --version"
        [npm]="npm --version"
    )

    for tool in "${!dev_tools[@]}"; do
        local version
        version=$(get_version "$tool" "${dev_tools[$tool]}")
        echo "- $tool: $version" >> "$SBOM_FILE"
    done

    # Platform Engineering Tools
    print_status "Analyzing platform engineering tools..."
    cat << 'EOF' >> "$SBOM_FILE"

### Platform Engineering Tools
EOF

    declare -A project_tools=(
        [idpbuilder]="idpbuilder version 2>&1 | awk '{print \$2}'"
        [kubara]="kubara --version 2>&1 | awk '{print \$3}'"
    )

    for tool in "${!project_tools[@]}"; do
        local version
        version=$(get_version "$tool" "${project_tools[$tool]}")
        echo "- $tool: $version" >> "$SBOM_FILE"
    done

    # Python Dependencies
    print_status "Analyzing Python dependencies..."
    cat << 'EOF' >> "$SBOM_FILE"

## 10. Verification

After installation, verify your setup by running:

```bash
# Run the tool checker script
./scripts/check-tools.sh

# Or generate this SBOM to see what's missing
./scripts/sbom-generator.sh
```

## 11. Security Considerations

- Regularly update all tools to their latest versions for security patches
- Use signed container images when available (cosign verification)
- Follow principle of least privilege for tool access
- Store sensitive data (passwords, tokens) in secure vaults
- Regularly scan dependencies for vulnerabilities using trivy/kubescape
- Enable audit logging in Kubernetes clusters
- Use network policies to restrict cluster communication

## 12. Support & Maintenance

- **Project Repository**: https://github.com/thatmlopsguy/dokaseca-control-plane
- **Documentation**: https://thatmlopsguy.github.io/dokaseca-control-plane/
- **Issue Tracking**: Report issues via GitHub Issues
- **License**: Apache License 2.0

For detailed installation instructions and troubleshooting, refer to the project
documentation at: https://thatmlopsguy.github.io/dokaseca-control-plane/

EOF

    print_success "SBOM generated successfully at: $SBOM_FILE"
    print_status "Total lines in SBOM: $(wc -l < "$SBOM_FILE")"
}

# Main execution
main() {
    print_header "SBOM Generator Initiated"

    # Check if we're in the right directory
    if [[ ! -f "$PROJECT_DIR/README.md" ]] || [[ ! -d "$PROJECT_DIR/scripts" ]]; then
        print_error "This script must be run from the Doka Seca project root or scripts directory"
        exit 1
    fi

    print_status "Project directory: $PROJECT_DIR"
    print_status "SBOM output file: $SBOM_FILE"

    # Generate SBOM
    generate_sbom

    print_success "SBOM generation completed!"
    print_status "You can view the SBOM at: $SBOM_FILE"
    print_status "To check which tools are missing, run: ./scripts/check-tools.sh"
}

# Handle script arguments
case "${1:-}" in
    --help|-h)
        cat << EOF
SBOM Generator for Doka Seca - Distributed Orchestration Kubernetes Automation with Scalable Edge Computing Applications

Usage: $0 [OPTIONS]

This script generates a comprehensive Software Bill of Materials (SBOM) for the
Doka Seca - Distributed Orchestration Kubernetes Automation with Scalable Edge
Computing Applications project, including all required tools, dependencies, and
components.

Options:
    --help, -h      Show this help message
    --version, -v   Show script version

The SBOM will be generated at: $SBOM_FILE

Examples:
    $0              # Generate SBOM
    $0 --help       # Show help
EOF
        exit 0
        ;;
    --version|-v)
        echo "SBOM Generator v1.0.0"
        exit 0
        ;;
    "")
        # No arguments, proceed with normal execution
        main
        ;;
    *)
        print_error "Unknown option: $1"
        print_status "Use --help for usage information"
        exit 1
        ;;
esac
