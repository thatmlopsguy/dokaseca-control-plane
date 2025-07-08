# Artifact Repositories

DoKa Seca leverages GitHub Container Registry (GHCR) as the default artifact repository for storing and distributing container images, Helm charts, and other platform artifacts. This integration provides seamless CI/CD workflows with built-in security scanning, access control, and package management capabilities.

## Overview

Artifact repositories are essential components of modern platform engineering, providing centralized storage for container images, Helm charts, and other deployment artifacts. DoKa Seca's integration with GitHub Container Registry offers:

- **Unified Platform**: Single platform for source code and artifacts
- **Integrated Security**: Built-in vulnerability scanning and security policies
- **Access Control**: Fine-grained permissions aligned with repository access
- **Cost Effective**: Free tier for public repositories and competitive pricing for private
- **GitOps Ready**: Native integration with GitOps workflows and ArgoCD

## Authentication and Security

### **GitHub Personal Access Tokens**

DoKa Seca uses GitHub Personal Access Tokens for registry authentication:

```bash
# Create token with required scopes
# - read:packages
# - write:packages (for pushing)
# - delete:packages (for cleanup)

# Login to GHCR
echo $GITHUB_TOKEN | docker login ghcr.io -u USERNAME --password-stdin
```

### **Kubernetes Secret Management**

Registry credentials are managed as Kubernetes secrets:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: ghcr-credentials
  namespace: default
type: kubernetes.io/dockerconfigjson
data:
  .dockerconfigjson: |
    {
      "auths": {
        "ghcr.io": {
          "username": "your-username",
          "password": "your-token",
          "auth": "base64-encoded-credentials"
        }
      }
    }
```

## CI/CD Integration

### **GitHub Actions Workflow**

DoKa Seca includes GitHub Actions workflows for automated image building and publishing:

```yaml
name: Build and Push Container Images

on:
  push:
    branches: [main]
    tags: ['v*']

jobs:
  build:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      packages: write

    steps:
    - uses: actions/checkout@v4

    - name: Login to GitHub Container Registry
      uses: docker/login-action@v3
      with:
        registry: ghcr.io
        username: ${{ github.actor }}
        password: ${{ secrets.GITHUB_TOKEN }}

    - name: Extract metadata
      id: meta
      uses: docker/metadata-action@v5
      with:
        images: ghcr.io/${{ github.repository }}
        tags: |
          type=ref,event=branch
          type=ref,event=pr
          type=semver,pattern={{version}}
          type=semver,pattern={{major}}.{{minor}}

    - name: Build and push
      uses: docker/build-push-action@v5
      with:
        context: .
        push: true
        tags: ${{ steps.meta.outputs.tags }}
        labels: ${{ steps.meta.outputs.labels }}
        platforms: linux/amd64,linux/arm64
```

### **ArgoCD Image Updater Integration**

Automated image updates in GitOps workflows:

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: my-app
  annotations:
    argocd-image-updater.argoproj.io/image-list: myapp=ghcr.io/your-org/my-app
    argocd-image-updater.argoproj.io/myapp.update-strategy: semver
    argocd-image-updater.argoproj.io/myapp.allow-tags: regexp:^v[0-9]+\.[0-9]+\.[0-9]+$
spec:
  # ... application specification
```

## Package Management

### **Package Visibility and Access**

GHCR supports different visibility levels:

- **Public**: Accessible to everyone
- **Private**: Restricted to organization members
- **Internal**: Accessible to organization and enterprise members

### **Package Metadata**

Rich metadata support for better package management:

```dockerfile
# Dockerfile with metadata labels
LABEL org.opencontainers.image.title="DoKa Seca Control Plane"
LABEL org.opencontainers.image.description="Platform engineering framework for Kubernetes"
LABEL org.opencontainers.image.source="https://github.com/your-org/dokaseca-control-plane"
LABEL org.opencontainers.image.documentation="https://dokaseca.dev/docs"
LABEL org.opencontainers.image.version="1.0.0"
```

### **Vulnerability Scanning**

GHCR provides built-in security scanning:

- **Automatic Scanning**: All pushed images are automatically scanned
- **Vulnerability Reports**: Detailed security vulnerability reports
- **Security Advisories**: Integration with GitHub security advisories
- **Policy Enforcement**: Block deployments of vulnerable images

## Best Practices

### **Image Management**

1. **Immutable Tags**: Use semantic versioning for production images
2. **Security Scanning**: Enable vulnerability scanning for all images
3. **Multi-Stage Builds**: Use multi-stage Dockerfiles to reduce image size
4. **Base Image Updates**: Regularly update base images for security patches
5. **Image Signing**: Use Cosign for image signing and verification

### **Repository Organization**

1. **Naming Conventions**: Follow consistent naming patterns
2. **Visibility Settings**: Set appropriate visibility levels for packages
3. **Access Control**: Use GitHub teams for repository and package access
4. **Documentation**: Maintain comprehensive package documentation
5. **Lifecycle Policies**: Implement retention policies for old packages

### **CI/CD Integration**

1. **Automated Builds**: Trigger builds on code changes
2. **Testing**: Include security and functionality testing in pipelines
3. **Promotion**: Use promotion workflows between environments
4. **Rollback**: Maintain rollback capabilities for failed deployments
5. **Monitoring**: Monitor registry usage and performance

## Troubleshooting

### **Common Issues**

**Authentication Failures**:

- Verify GitHub token has required scopes
- Check token expiration date
- Ensure correct username/token combination

**Image Pull Errors**:

- Verify image exists and is accessible
- Check network connectivity to registry
- Validate image tag and repository name

**Build and Push Failures**:

- Check Docker daemon status
- Verify disk space for image building
- Validate Dockerfile syntax

### **Getting Help**

- Review GitHub Container Registry documentation
- Check DoKa Seca registry configuration examples
- Examine platform logs for registry-related errors
- Engage with the platform engineering team for support

## Migration Guide

### **Migrating from Other Registries**

DoKa Seca provides migration tools for transitioning from other container registries:

```bash
# Migration script example
#!/bin/bash
SOURCE_REGISTRY="docker.io/myorg"
TARGET_REGISTRY="ghcr.io/myorg"

# Pull, retag, and push images
for image in $(docker images --format "{{.Repository}}:{{.Tag}}" | grep $SOURCE_REGISTRY); do
  new_image=${image/$SOURCE_REGISTRY/$TARGET_REGISTRY}
  docker tag $image $new_image
  docker push $new_image
done
```
