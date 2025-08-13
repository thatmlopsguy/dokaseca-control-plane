# GitOps Kubernetes Addons

This guide explains how to deploy Kubernetes addons using the GitOps Bridge pattern in DoKa Seca.
The GitOps Bridge enables automated deployment and management of cluster-level components through declarative configuration and ArgoCD ApplicationSets.

## Introduction

The GitOps Bridge Addon system provides:

* **Automated Addon Deployment**: Deploy cluster addons declaratively through Git
* **Environment-Specific Configuration**: Different addon configurations per environment
* **Dependency Management**: Control addon deployment order and dependencies
* **Lifecycle Management**: Automated updates and rollbacks through GitOps
* **Multi-Cluster Support**: Deploy addons across multiple clusters consistently

## Architecture

The addon deployment follows this workflow:

1. **Addon Configuration**: Define addon manifests in the addons repository
2. **Cluster Annotations**: Configure which addons to deploy per cluster
3. **ApplicationSet Discovery**: ArgoCD discovers addon configurations
4. **Automated Deployment**: ArgoCD deploys addons to target clusters
5. **Continuous Sync**: Monitor and maintain desired state

## Repository Structure

DoKa Seca uses the Git repository [`dokaseca-addons`](https://github.com/thatmlopsguy/dokaseca-addons) with the following structure:

```
dokaseca-addons/
├── argocd/
│   └── appsets/                # ApplicationSet definitions
│       ├── oss/                # Open source addons
│       │   ├── networking/     # Network-related addons
│       │   ├── observability/  # Monitoring and observability
│       │   ├── security/       # Security tools
│       │   ├── storage/        # Storage solutions
│       │   ├── databases/      # Database operators
│       │   ├── gitops/         # GitOps tools
│       │   └── ...
│       ├── aws/                # AWS-specific addons
│       ├── azure/              # Azure-specific addons
│       ├── gcp/                # GCP-specific addons
│       └── enterprise/         # Enterprise addons
│
├── clusters/                   # Cluster-specific configurations
│   └── control-plane-dev/
│       └── addons/
│           ├── metallb/
│           ├── argo-cd/
│           └── ...
│
├── environments/               # Environment-specific values
│   ├── default/                # Default values for all environments
│   │   └── addons/
│   ├── dev/                    # Development environment
│   │   └── addons/
│   ├── stg/                    # Staging environment
│   │   └── addons/
│   └── prod/                   # Production environment
│       └── addons/
│
└── kustomize/                  # Kustomization resources
    ├── gateway-api/
    ├── gitops-promoter/
    └── ...
```

## Deploying a New Addon

### Step 1: Create ApplicationSet Definition

Create an ApplicationSet in the appropriate category directory:

**Example: MetalLB LoadBalancer** (`argocd/appsets/oss/networking/addons-metallb-appset.yaml`):

```yaml
---
apiVersion: argoproj.io/v1alpha1
kind: ApplicationSet
metadata:
  name: addons-metallb
  namespace: argocd
  annotations:
    argocd.argoproj.io/sync-wave: '-20'
spec:
  syncPolicy:
    preserveResourcesOnDeletion: false
  generators:
    - merge:
        mergeKeys: [server]
        generators:
          - clusters:
              values:
                addonChart: metallb
                addonChartVersion: 0.14.8
                addonChartRepository: https://metallb.github.io/metallb
                addonChartNamespace: metallb-system
                addonChartRepositoryExtra: https://thatmlopsguy.github.io/helm-charts
                addonChartExtraVersion: 0.1.0
              selector:
                matchExpressions:
                  - key: enable_metallb
                    operator: In
                    values: ['true']
          - clusters:
              selector:
                matchLabels:
                  environment: dev
              values:
                addonChartVersion: 0.14.8
                addonChartExtraVersion: 0.1.0
          - clusters:
              selector:
                matchLabels:
                  environment: prod
              values:
                addonChartVersion: 0.14.8
                addonChartExtraVersion: 0.1.0
  template:
    metadata:
      name: addon-{{name}}-{{values.addonChart}}
    spec:
      project: addons
      sources:
        - repoURL: '{{metadata.annotations.addons_repo_url}}'
          targetRevision: '{{metadata.annotations.addons_repo_revision}}'
          ref: values
        - chart: '{{values.addonChart}}'
          repoURL: '{{values.addonChartRepository}}'
          targetRevision: '{{values.addonChartVersion}}'
          helm:
            releaseName: '{{values.addonChart}}'
            ignoreMissingValueFiles: true
            valueFiles:
              - $values/environments/default/addons/{{values.addonChart}}/values.yaml
              - $values/environments/{{metadata.labels.environment}}/addons/{{values.addonChart}}/values.yaml
              - $values/clusters/{{name}}/addons/{{values.addonChart}}/values.yaml
        - chart: '{{values.addonChart}}-extras'
          repoURL: '{{values.addonChartRepositoryExtra}}'
          targetRevision: '{{values.addonChartExtraVersion}}'
          helm:
            releaseName: '{{values.addonChart}}-extras'
            ignoreMissingValueFiles: true
            valueFiles:
              - $values/environments/default/addons/{{values.addonChart}}/extras.yaml
              - $values/environments/{{metadata.labels.environment}}/addons/{{values.addonChart}}/extras.yaml
              - $values/clusters/{{name}}/addons/{{values.addonChart}}/extras.yaml
      destination:
        namespace: '{{values.addonChartNamespace}}'
        name: '{{name}}'
      syncPolicy:
        automated: {}
        syncOptions:
          - CreateNamespace=true
```

### Step 2: Configure Default Values

Create default values for the addon (`environments/default/addons/metallb/values.yaml`):

```yaml
# Default MetalLB configuration
metallb:
  # Default speaker configuration
  speaker:
    frr:
      enabled: false
    memberlist:
      enabled: true
      secretKey: "metallbspeakersecret"

  # Default controller configuration  
  controller:
    replicas: 1
    resources:
      limits:
        cpu: 100m
        memory: 100Mi
      requests:
        cpu: 100m
        memory: 100Mi

# MetalLB IP Pool Configuration (environment-specific)
ipAddressPools:
  - name: default-pool
    protocol: layer2
    addresses:
    - 192.168.1.240-192.168.1.250

l2Advertisements:
  - name: default-advertisement
    ipAddressPools:
    - default-pool
```

### Step 3: Environment-Specific Overrides

Create environment-specific values (`environments/dev/addons/metallb/values.yaml`):

```yaml
# Development environment MetalLB overrides
ipAddressPools:
  - name: dev-pool
    protocol: layer2
    addresses:
    - 172.18.255.200-172.18.255.210

l2Advertisements:
  - name: dev-advertisement
    ipAddressPools:
    - dev-pool
```

### Step 4: Cluster-Specific Configuration

For cluster-specific settings (`clusters/control-plane-dev/addons/metallb/values.yaml`):

```yaml
# Cluster-specific MetalLB configuration
metallb:
  controller:
    replicas: 2  # High availability for this cluster

# Additional resources for this cluster
extraResources:
  - apiVersion: metallb.io/v1beta1
    kind: IPAddressPool
    metadata:
      name: cluster-specific-pool
      namespace: metallb-system
    spec:
      addresses:
      - 10.0.0.100-10.0.0.110
```

### Step 5: Enable Addon on Cluster

Add the addon annotation to the cluster secret to enable deployment via terraform `tfvars` file:

```hcl
addons = {
  # dashboard
  enable_kubernetes_dashboard = false
  enable_headlamp             = false
  enable_helm_dashboard       = false
  enable_komoplane            = false
  enable_altinity_dashboard   = false
  enable_dapr_dashboard       = false
  enable_ocm_dashboard        = false
  enable_metallb              = true  # <- it will install the
}
```

You can see that terraform will add GitOps Bridge Metadata to the ArgoCD secret.
The annotations contain metadata for the addons' Helm charts and ArgoCD ApplicationSets.

```sh
kubectl get secret -n argocd -l argocd.argoproj.io/secret-type=cluster -o json | jq '.items[0].metadata.labels'
```

The output looks like the following:

```json
{
  "argocd.argoproj.io/secret-type": "cluster",
  "cloud_provider": "local",
  "cluster_name": "hub-dev",
  "enable_alloy": "false",
  "enable_argo_cd": "true",
  "enable_argo_cd_image_updater": "false",
  "enable_argo_events": "false",
  "enable_argo_rollouts": "false",
  "enable_argo_workflows": "false",
  "enable_metallb": "true",  # <- it will install the MetalLB addon
  "enable_trivy": "false",
  "enable_vault": "false",
  "enable_vcluster": "false",
  "enable_vector": "false",
  "enable_zipkin": "false",
  "environment": "dev",
  "k8s_cluster_name": "hub-dev",
  "k8s_domain_name": "dokaseca.local",
  "kubernetes_version": "1.31.2"
}
```

The ApplicationSet automatically discovers clusters with the addon annotation and deploys the addon.

The ApplicationSet will:

1. **Discover Clusters**: Find all clusters with  `enable_metallb: "true"`
2. **Generate Applications**: Create ArgoCD Applications for each matching cluster
3. **Deploy Addon**: Install MetalLB using Helm with appropriate value files
4. **Monitor State**: Continuously sync and maintain desired state

## Available Addon Categories

DoKa Seca organizes addons into logical categories. The addons catalog can be found in the [GitHub repository](https://github.com/dokaseca/dokaseca-addons).

## Advanced Configuration

### Dependency Management

Use ArgoCD sync waves to control deployment order:

```yaml
# In addon manifests
metadata:
  annotations:
    argocd.argoproj.io/sync-wave: "1"  # Deploy first
```
