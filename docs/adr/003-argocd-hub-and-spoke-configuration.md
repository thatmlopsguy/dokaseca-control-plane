# ArgoCD Hub and Spoke Configuration for Multi-Cluster GitOps

Date: 2025-07-11

## Status

Accepted

## Context

DoKa Seca requires a scalable GitOps solution to manage applications and configurations across multiple Kubernetes clusters in different environments (dev, staging, production) and serving different teams. The platform needs to support:

- **Multi-Cluster Management**: Centralized management of multiple Kubernetes clusters
- **Team Isolation**: Separate development teams (team-a, team-b, team-c) with isolated workspaces
- **Environment Promotion**: Consistent application promotion from `dev → staging → production`
- **Security Boundaries**: Proper RBAC and network isolation between clusters
- **Operational Efficiency**: Centralized monitoring and management while maintaining cluster autonomy

The main architectural patterns considered were:

1. **Single ArgoCD per Cluster**: Independent ArgoCD instance in each cluster
2. **Centralized ArgoCD**: Single ArgoCD managing all clusters from one location
3. **Hub and Spoke**: Central ArgoCD hub with satellite clusters registered as remote targets

Each approach has different trade-offs in terms of complexity, security, and operational overhead.

## Decision

DoKa Seca will implement ArgoCD in a **hub and spoke configuration** with the following architecture:

### **1. Hub Cluster (Control Plane)**

Deploy a central ArgoCD instance in the control-plane cluster that acts as the management hub:

- **Central GitOps Controller**: Single point of GitOps orchestration
- **Cluster Registry**: Manages connections to all spoke clusters
- **Application Catalog**: Centralized application definitions and policies
- **Monitoring Dashboard**: Unified view of all cluster deployments

### **2. Spoke Clusters (Workload Clusters)**

Register workload clusters as remote targets with the hub:

- **workloads-dev**: Development environment cluster with team-specific namespaces
- **workloads-stg**: Staging environment cluster with team-specific namespaces  
- **workloads-prod**: Production environment cluster with team-specific namespaces

Each workload cluster contains dedicated namespaces for team isolation:

- **team-a**: Team A's namespaces across environments
- **team-b**: Team B's namespaces across environments
- **team-c**: Team C's namespaces across environments
- **Namespace-level RBAC**: Team isolation through Kubernetes RBAC and network policies

### **3. GitOps Repository Structure**

Organize Git repositories to support the hub and spoke model with namespace-based team isolation:

**Workloads Repository (DoKa-seca-workloads):**

```text
├── environments/
│   ├── dev/                     # Development environment
│   │   ├── team-a/              # Team A applications in dev
│   │   ├── team-b/              # Team B applications in dev
│   │   └── team-c/              # Team C applications in dev
│   │
│   ├── stg/                     # Staging environment
│   │   ├── team-a/              # Team A applications in staging
│   │   ├── team-b/              # Team B applications in staging
│   │   └── team-c/              # Team C applications in staging
│   │
│   └── prod/                    # Production environment
│       ├── team-a/              # Team A applications in production
│       ├── team-b/              # Team B applications in production
│       └── team-c/              # Team C applications in production
│
└── kustomize/                   # Kustomize overlays for environments
```

### **4. Security Model**

Implement proper security boundaries:

- **Service Accounts**: Dedicated service accounts per cluster with minimal required permissions
- **ArgoCD Projects**: Team-specific projects with RBAC enforcement
- **Network Policies**: Secure communication between hub and spokes
- **Secret Management**: External Secrets Operator with Vault integration

### **5. Application Management**

Use the "App of Apps" pattern for scalable application management:

- **Root Applications**: Hub manages high-level application definitions
- **Team Applications**: Teams manage their specific application configurations
- **Platform Applications**: Shared infrastructure components managed centrally

## Consequences

### **Positive Consequences**

- **Centralized Management**: Single pane of glass for all GitOps operations across clusters
- **Operational Efficiency**: Reduced operational overhead compared to multiple ArgoCD instances
- **Consistent Policies**: Platform-wide policies and standards enforced centrally
- **Team Autonomy**: Teams can manage their applications while respecting platform boundaries
- **Scalability**: Easy to add new clusters and teams to the hub
- **Monitoring**: Unified monitoring and alerting for all GitOps operations
- **Disaster Recovery**: Hub cluster can be restored independently of workload clusters
- **Cost Optimization**: Single ArgoCD deployment reduces resource overhead

### **Negative Consequences**

- **Single Point of Failure**: Hub cluster failure affects GitOps operations across all clusters
- **Network Dependency**: Requires stable network connectivity between hub and spokes
- **Complexity**: More complex initial setup compared to single-cluster deployments
- **Hub Cluster Sizing**: Hub cluster must be sized to handle load from all spokes
- **Security Scope**: Compromise of hub cluster could affect all managed clusters
- **Troubleshooting**: Cross-cluster issues may be more complex to diagnose

### **Mitigation Strategies**

- **Hub High Availability**: Deploy ArgoCD hub in HA configuration with multiple replicas
- **Network Resilience**: Implement robust networking with failover mechanisms
- **Cluster Autonomy**: Spoke clusters can operate independently for critical services
- **Security Hardening**: Implement comprehensive security controls and monitoring
- **Documentation**: Maintain detailed runbooks for troubleshooting cross-cluster issues
- **Backup Strategy**: Regular backups of ArgoCD configurations and Git repositories

## Implementation Details

### **Team Project Configuration**

```yaml
apiVersion: argoproj.io/v1alpha1
kind: AppProject
metadata:
  name: team-a
  namespace: argocd
spec:
  description: Team A applications across all environments
  sourceRepos:
  - 'https://github.com/dokaseca/doka-seca-workloads/environments/*/team-a/*'
  destinations:
  - namespace: 'team-a'
    server: https://workloads-dev.dokaseca.local:6443
  clusterResourceWhitelist:
  - group: ''
    kind: Namespace
  namespaceResourceWhitelist:
  - group: '*'
    kind: '*'
```

## References

- [Distribute Your Argo CD Applications to Different Kubernetes Clusters Using Application Sets](https://codefresh.io/blog/argocd-clusters-labels-with-apps/)
- [DoKa Seca GitOps Documentation](../gitops.md)
- [DoKa Seca Multi-Cluster Architecture](../getting_started/architecture.md)

## Authors

- Platform Engineering Team
- DevOps Team

## Review History

| Date | Reviewer | Status | Comments |
|------|----------|--------|----------|
| 2025-07-11 | Initial | Draft | Initial proposal for ArgoCD hub and spoke architecture |
