# GitOps Kubernetes Workflows

## Introduction

DoKa Seca provides flexibility in choosing the right GitOps promotion strategy for your workloads through three complementary tools: [Kargo](https://kargo.io/) is the **default and recommended** promotion tool for DoKa Seca workloads, [ArgoCD Image Updater](https://argocd-image-updater.readthedocs.io/) or [GitOps Promoter](https://github.com/argoproj-labs/gitops-promoter).

These three tools work in conjunction with ArgoCD to provide a complete GitOps workflow for continuous delivery. While ArgoCD handles the core GitOps functionality of synchronizing Git repository state with Kubernetes clusters, Kargo, ArgoCD Image Updater, and GitOps Promoter extend this capability by automating the promotion of applications across environments. They integrate seamlessly with ArgoCD's declarative approach, automatically updating Git repositories with new image versions or configuration changes, which ArgoCD then detects and deploys according to its synchronization policies.

## Repository Structure

DoKa Seca uses an external repository to organize the workloads, see [`dokaseca-workloads`](https://github.com/thatmlopsguy/dokaseca-workloads), for each team, following a structured approach that separates platform configuration from workload definitions. The repository structure is designed to support multi-team environments with clear separation of concerns:

```
├── README.md
├── argocd
│   ├── platform
│   │   ├── exclude
│   │   └── team-a
│   │       ├── project-a
│   │       │   └── kargo
│   │       │       ├── kargo-secret.yaml #
│   │       │       ├── project.yaml
│   │       │       ├── promotiontasks.yaml
│   │       │       ├── stages
│   │       │       │   ├── dev.yaml
│   │       │       │   ├── prod.yaml
│   │       │       │   └── stg.yaml
│   │       │       └── warehouse.yaml
│   │       └── project-b
│   │           └── project.yaml
│   └── workloads
│       ├── exclude
│       ├── team-a
│       │   ├── project-a
│       │   │   └── applicationset.yaml
│       │   ├── project-b
│       │   │   └── applicationset.yaml
│       │   └── project.yaml
│       ├── team-b
│       │   ├── project-a
│       │   ├── project-b
│       │   └── project.yaml
│       └── team-c
│           ├── project-a
│           ├── project-b
│           └── project.yaml
```

### Key Structure Components

- **`argocd/platform/`**: Contains Kargo-specific configurations for GitOps promotion workflows, including stages (dev, stg, prod), promotion tasks, and warehouse definitions
- **`argocd/workloads/`**: Contains ArgoCD ApplicationSets and project configurations that define how applications are deployed across environments
- **Team Organization**: Each team has its own directory structure under both platform and workloads, enabling team-specific configurations while maintaining consistency
- **Project Isolation**: Individual projects within teams have their own subdirectories, allowing for project-specific deployment strategies and configurations

## ApplicationSet Example

DoKa Seca leverages ArgoCD ApplicationSets to deploy workloads across multiple environments and clusters.

Below is an example ApplicationSet that demonstrates how to deploy a Python API application across different environments with environment-specific configurations:

```yaml
apiVersion: argoproj.io/v1alpha1
kind: ApplicationSet
metadata:
  name: kargo-python-api
  namespace: argocd
spec:
  goTemplate: true
  goTemplateOptions: ["missingkey=error"]
  generators:
    - merge:
        mergeKeys: [server]
        generators:
          - clusters:
              selector:
                matchLabels:
                  type: "workload"
                  team-a: "true"
              values:
                chartVersion: "0.4.0" # Default chart version
          - clusters:
              selector:
                matchLabels:
                  env: dev
              values:
                chartVersion: "0.4.0" # Default helm chart version for dev
          - clusters:
              selector:
                matchLabels:
                  env: stg
              values:
                chartVersion: "0.3.0" # Default chart version for staging
          - clusters:
              selector:
                matchLabels:
                  env: prod
              values:
                chartVersion: "0.2.0" # Default chart version for production
  template:
    metadata:
      name: python-api-helm-{{.name}}
      # annotations:
      # https://docs.kargo.io/user-guide/how-to-guides/argo-cd-integration#authorizing-updates
      #  kargo.akuity.io/authorized-stage: kargo-simple-python-demo:{{.metadata.labels.env}} # "<project-name>:<stage-name>"
      #   argocd-image-updater.argoproj.io/write-back-method: git
      #   argocd-image-updater.argoproj.io/write-back-target: kustomization
      #   argocd-image-updater.argoproj.io/image-list: python-app=ghcr.io/thatmlopsguy/python-demo-api
      #   argocd-image-updater.argoproj.io/python-app.update-strategy: latest
      #   argocd-image-updater.argoproj.io/python-app.allow-tags: regexp:^{{.metadata.labels.env}}.[0-9a-f]{7}$
      #   argocd-image-updater.argoproj.io/python-app.ignore-tags: latest, master
    spec:
      project: workloads-team-a
      sources:
        - repoURL: https://github.com/thatmlopsguy/python-api.git
          targetRevision: HEAD
          ref: root
        - repoURL: ghcr.io/<org>/charts # helm chart repository
          chart: global # helm chart used for all applications
          targetRevision: '{{.values.chartVersion}}'
          helm:
            valueFiles:
              - '$root/chart/simple/values/common.yaml'
              - '$root/chart/simple/values/envs/{{.metadata.labels.env}}.yaml'
              - '$root/chart/simple/values/regions/{{.metadata.labels.region}}.yaml'
      destination:
        server: '{{.server}}'
        namespace: 'python-demo-{{.metadata.labels.env}}'
      syncPolicy:
        automated:
          prune: true
          selfHeal: true
        syncOptions:
        - Validate=true
        - CreateNamespace=true
```

### ApplicationSet Key Features

This example ApplicationSet demonstrates several important patterns used in DoKa Seca:

- **Multi-Environment Deployment**: Uses merge generators to deploy across different environments (dev, stg, prod) with environment-specific configurations
- **Team-Based Targeting**: Targets clusters labeled with `team-a: "true"` to ensure workloads are deployed only to appropriate team clusters
- **Version Management**: Different chart versions per environment, allowing for controlled rollouts and testing
- **Global Helm Chart Stability**: The global helm chart referenced in the ApplicationSet is designed for stability and is not upgraded frequently. This approach ensures consistency across all applications while minimizing disruption from chart-level changes, allowing teams to focus on application-specific updates rather than infrastructure changes
- **Multiple Sources**: Combines Git repository sources with OCI Helm chart registries for flexible deployment strategies
- **Value File Hierarchies**: Uses environment and region-specific value files for fine-grained configuration management
- **GitOps Integration**: Commented annotations show integration points for Kargo and ArgoCD Image Updater workflows
- **Automated Sync**: Configured for automated synchronization with pruning and self-healing capabilities

## Cluster Labeling for Team Targeting

To enable team-based targeting as shown in the ApplicationSet example above, you need to add the appropriate team labels to the ArgoCD cluster secrets. The `team-a: "true"` label in the cluster selector ensures that workloads are deployed only to clusters belonging to that specific team.

To add this label to an ArgoCD cluster secret, you can either modify the existing cluster secret directly or use the DoKa Seca Terraform configuration. In the cluster secret, add the label under the `metadata.labels` section:

```yaml
metadata:
  labels:
    team-a: "true"
    type: "workload"
    env: "dev"  # or stg, prod
    region: "us-east-1"  # your specific region
    cloud: "local"
```

This labeling strategy allows ApplicationSets to precisely target the right clusters based on team ownership, environment, and geographical region, ensuring proper workload isolation and deployment control across your multi-cluster setup.

## References

- [Distribute Your Argo CD Applications to Different Kubernetes Clusters Using Application Sets](https://codefresh.io/blog/argocd-clusters-labels-with-apps/)
- [Abusing the Target Revision Field for Argo CD Promotions](https://codefresh.io/blog/argocd-application-target-revision-field/)
