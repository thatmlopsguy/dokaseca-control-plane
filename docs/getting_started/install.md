# DoKa Seca Installation

Welcome to DoKa Seca! This guide will help you set up the complete framework for bootstrapping cloud-native platforms using Kubernetes in Docker (Kind). DoKa Seca provides an opinionated, production-ready approach to rapidly deploying a full platform stack with GitOps, observability, and security built-in.

## Prerequisites

Before installing DoKa Seca, ensure you have the following prerequisites installed on your system:

### Required Tools

* **[Docker](https://www.docker.com/)** - Container runtime for Kind clusters
* **[Kind](https://kind.sigs.k8s.io/docs/user/quick-start/)** - Kubernetes in Docker for local clusters
* **[Terraform](https://www.terraform.io/) or [OpenTofu](https://opentofu.org/)** - Infrastructure as Code tool
* **[kubectl](https://kubernetes.io/docs/tasks/tools/)** - Kubernetes command-line tool
* **[Helm](https://helm.sh/docs/intro/install/)** - Kubernetes package manager
* **[jq](https://jqlang.github.io/jq/)** - JSON processor for configuration management
* **[Kustomize](https://kustomize.io/)** - Kubernetes configuration management

### Optional Tools (Recommended)

* **[k9s](https://k9scli.io/)** or **[Lens](https://k8slens.dev/)** - Visual cluster inspection
* **[ArgoCD CLI](https://argo-cd.readthedocs.io/en/stable/cli_installation/)** - GitOps workflow management
* **[Cosign](https://github.com/sigstore/cosign)** - Container image signing
* **[Velero](https://github.com/vmware-tanzu/velero)** - Backup and restore

### System Requirements

* **OS**: Linux, macOS, or Windows (with WSL2)
* **Memory**: Minimum 8GB RAM (16GB recommended)
* **CPU**: 4+ cores recommended
* **Disk**: 20GB+ free space
* **Network**: Internet access for pulling container images

## Quick Start Installation

DoKa Seca provides a streamlined installation process that bootstraps your entire platform with a single command:

### 1. Fork the Repository

```bash
git clone https://github.com/org/dokaseca-control-plane.git
cd dokaseca-control-plane
```

### 2. Bootstrap Your Platform

Create a Kind cluster with the complete DoKa Seca platform stack:

```bash
./scripts/terraform.sh hub dev apply
```

This command will:

* Create a Kind cluster named `hub-dev`
* Install the core platform components
* Configure GitOps workflows with ArgoCD (if enabled)
* Set up observability stack
* Apply security policies

### 3. Verify Installation

Check that your cluster is running:

```bash
kind get clusters
# Output: hub-dev

kubectl cluster-info
kubectl get nodes
```

### 4. Access Platform Components

If GitOps is enabled (`enable_gitops_bridge = true` in terraform.tfvars), you can access various platform components:

```bash
# Get ArgoCD admin password
make argo-cd-password

# Port-forward to access ArgoCD UI
kubectl port-forward svc/argocd-server -n argocd 8080:443
# Access: https://localhost:8080
```

## Configuration Options

DoKa Seca supports various configuration options through `terraform.tfvars`:

```hcl
# Enable GitOps workflow
enable_gitops_bridge = true

# Configure cluster settings
cluster_name = "hub-dev"
environment = "dev"

# Enable specific addons
enable_argo_cd = true
enable_victoria_metrics_k8s_stack = true
enable_vault = false
# ... additional addon configurations
```

## Platform Components

Once installed, DoKa Seca provides:

* **GitOps**: ArgoCD for declarative application deployment
* **Observability**: Victoria Metrics stack for monitoring and alerting
* **Security**: Pod Security Standards and admission controllers
* **Networking**: Ingress controllers and service mesh (optional)
* **Storage**: Persistent volume management
* **Backup**: Velero for disaster recovery (optional)

## Troubleshooting

### Increase File Limits

If you encounter "too many open files" errors:

```bash
sudo sysctl fs.inotify.max_user_watches=1048576
sudo sysctl fs.inotify.max_user_instances=8192
```

### Clean Installation

To completely remove and reinstall:

```bash
./scripts/terraform.sh hub dev destroy
# Wait for cleanup to complete
./scripts/terraform.sh hub dev apply
```

## Next Steps

After installation:

1. **Explore the Platform**: Check the [Architecture](architecture.md) guide
2. **Deploy Applications**: Learn about the [Catalog](../catalog.md)
3. **Configure GitOps**: Set up your [Repository](../repository.md) workflows
4. **Monitor**: Access [Observability](../observability.md) dashboards
5. **Secure**: Review [Security](../security.md) policies

For more detailed configuration and usage, continue to the [Architecture](architecture.md) section.
