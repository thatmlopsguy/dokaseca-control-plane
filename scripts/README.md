# DoKa Seca Development Scripts

This directory contains automation scripts and utilities for developing, deploying, and managing the DoKa Seca platform. These scripts streamline common development tasks and platform operations.

## 📋 Prerequisites

- **Bash/Shell environment** (Linux/macOS recommended)
- **Git** - For repository operations
- **kubectl** - For Kubernetes cluster interaction
- **Docker** - For container operations (if using local clusters)

## 🛠️ Platform Management Scripts

### Infrastructure & Deployment

- **`terraform.sh`** - Terraform automation script for applying/destroying infrastructure configurations

  ```bash
  ./terraform.sh <cluster-type> <environment> <action>
  # Examples:
  ./terraform.sh control-plane dev apply
  ./terraform.sh workloads prod destroy
  ```

### Kubernetes Cluster Setup

- **`install-kind.sh`** - Install and configure the latest verified Kubernetes cluster using KinD (Kubernetes in Docker)
- **`install-cilium-cli.sh`** - Install Cilium CLI tool for network policy management and observability

## 🔐 Security & Authentication

### ArgoCD Management

- **`argocd-password.sh`** - Generate bcrypt hash for ArgoCD admin password
- **`argocd-token.sh`** - Retrieve and manage ArgoCD authentication tokens

## 📊 Observability & Monitoring

## 🚢 GitOps & Application Delivery

### Kargo (Application Promotion)

- **`download-kargo-cli.sh`** - Download and install Kargo CLI for application promotion workflows
- **`kargo-quickstart.sh`** - Quick setup script for Kargo promotion pipelines

## 🌐 Network & Infrastructure

- **`generate-hosts-entries.sh`** - Generate /etc/hosts entries for local development and testing

## 🔧 Development Hooks

The `hooks/` directory contains Git hooks and automation scripts:

- **`hooks/terraform-docs.sh`** - Generate Terraform documentation automatically

## 🚀 Quick Start

### 1. Set up a local development cluster

```bash
# Install KinD and create a cluster
./install-kind.sh

# Install essential networking tools
./install-cilium-cli.sh
```

### 2. Deploy platform infrastructure

```bash
# Apply control-plane infrastructure for development
./terraform.sh control-plane dev apply

# Initialize Vault for secret management
./vault-init.sh
```

### 3. Configure GitOps

```bash
# Set up ArgoCD with custom password
./argocd-password.sh

# Install Kargo for application promotion
./download-kargo-cli.sh
./kargo-quickstart.sh
```

### 4. Enable observability

```bash
# Deploy monitoring dashboards
./dashboards.sh
```

## 📝 Usage Guidelines

### Script Execution

1. **Make scripts executable**:

   ```bash
   chmod +x *.sh
   ```

2. **Run from scripts directory**:

   ```bash
   cd scripts/
   ./script-name.sh
   ```

3. **Check script help/usage**:
   Most scripts support `--help` or `-h` flags for usage information.

### Environment Variables

Some scripts may require environment variables:

- `KUBECONFIG` - Path to Kubernetes configuration
- `VAULT_ADDR` - Vault server address
- `ARGOCD_SERVER` - ArgoCD server endpoint
