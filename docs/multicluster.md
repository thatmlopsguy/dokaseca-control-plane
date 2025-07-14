# Multi cluster

Kubernetes multi-cluster setups are increasingly common for scaling, isolation, and resilience. In this project, we use one cluster per environment: **dev**, **stg**, and **prod**. This approach provides clear separation and reduces blast radius between environments.

## Pets vs Cattle

When managing clusters, it's important to treat them as **cattle, not pets**. This means clusters should be reproducible, disposable, and managed declaratively (e.g., via GitOps), rather than being unique, hand-crafted, or irreplaceable. This mindset enables automation, scalability, and reliability.

## Multi-Cluster Topologies

There are several ways to organize and connect multiple Kubernetes clusters:

- **Standalone/Distributed:** Each cluster operates independently, with its own control plane and management. This is simple and works well for clear environment separation (as in our current setup).
- **Centralized (Hub/Spoke):** A central "hub" cluster manages or coordinates multiple "spoke" clusters. This can simplify policy management, observability, and cross-cluster workflows, but adds complexity and a potential single point of failure.

> **Note:** Currently, we use the standalone/distributed topology with one cluster per environment. Future enhancements may explore centralized management for advanced use cases.

## GitOps Bridge Topologies

When using GitOps to manage multiple clusters, there are two main approaches:

- **Standalone/Distributed GitOps:** Each cluster has its own GitOps controller (e.g., Argo CD or Flux), managing only its resources. This matches our current topology and is simple to operate.
- **Centralized (Hub/Spoke) GitOps:** A central GitOps controller manages resources across multiple clusters. This can enable global policies, shared services, and easier cross-cluster coordination, but requires careful RBAC and security design.

## Cluster Creation and Management

DoKa Seca is planning to enhance multi-cluster capabilities through automated cluster provisioning and management using
two complementary approaches: Cluster API with KRO, and Crossplane.

### Cluster API (CAPI)

[Cluster API](https://cluster-api.sigs.k8s.io/) provides declarative APIs and tooling to simplify provisioning, upgrading,
and operating multiple Kubernetes clusters.

#### Planned Implementation

DoKa Seca will utilize Cluster API for:

- **Infrastructure-agnostic cluster creation:** Using CAPI providers for AWS, Azure, GCP, and on-premises (via vSphere and bare metal)
- **Standardized cluster templates:** Creating reusable cluster blueprints with pre-configured settings for each environment
- **Lifecycle management:** Enabling seamless upgrades and scaling operations across clusters

### KRO (Kubernetes Resource Orchestration)

[KRO](https://github.com/kro-project) will be used to simplify cross-cluster resource management, enabling DoKa Seca to:

- **Coordinate multi-cluster deployments:** Manage application lifecycles across cluster boundaries
- **Handle dependencies between clusters:** Ensure proper sequencing of resource creation
- **Implement advanced rollout strategies:** Control the deployment flow across multiple environments

#### Planned Integration

KRO will work alongside ArgoCD to provide more sophisticated orchestration between clusters, especially for complex application
topologies spanning multiple clusters.

### Crossplane

[Crossplane](https://www.crossplane.io/) will enable DoKa Seca to define and use higher-level abstractions for both
infrastructure and applications, making it easier to manage complex deployments.

#### Planned Capabilities

- **Infrastructure provisioning:** Create cloud resources (VPCs, databases, etc.) alongside Kubernetes clusters
- **Composition of complex resources:** Define reusable templates for complete application stacks
- **Self-service platform:** Allow teams to provision environments via simple custom resources

## Integration Strategy

DoKa Seca plans to integrate these tools in a complementary fashion:

1. **Cluster API** will handle the core cluster provisioning and lifecycle management
2. **KRO** will manage application deployment orchestration across clusters
3. **Crossplane** will provide higher-level abstractions and additional infrastructure resources

The initial implementation will focus on standardizing cluster creation for dev, staging, and production environments
using Cluster API, with KRO and Crossplane capabilities being integrated in subsequent phases.

## References

- [Building a Bridge between Terraform and ArgoCD](https://www.slideshare.net/CarlosSantana1/building-a-bridge-between-terraform-and-argocd)
- [Cluster API Documentation](https://cluster-api.sigs.k8s.io/introduction.html)
- [KRO Project](https://github.com/kro-project)
- [Crossplane Documentation](https://docs.crossplane.io/)
