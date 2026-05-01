# Multi-Tenancy

Multi-tenancy in Kubernetes refers to sharing a cluster among multiple users, teams, or applications (tenants) while providing isolation between them.

## Types of Multi-Tenancy

Multi-tenancy can be divided into two categories:

### Soft Multi-Tenancy

Soft multi-tenancy is suitable **when you trust your tenants** — like when you share a cluster with teams from the same company. In this model:

- Tenants are cooperative and don't intentionally try to breach isolation
- Isolation is primarily about preventing accidental interference
- You can use native Kubernetes constructs like Namespaces, RBAC, and Resource Quotas

### Hard Multi-Tenancy

Hard multi-tenancy is required **when you don't trust tenants** — such as in SaaS platforms where customers from different organizations share infrastructure. In this model:

- Strong isolation is mandatory
- Tenants may be hostile or attempt to escape their boundaries
- Security boundaries must be enforced at multiple levels

!!! warning "Hard Multi-Tenancy Recommendation"
    If you need hard multi-tenancy, the advice is to use **multiple clusters** or a **Cluster-as-a-Service** tool instead. Kubernetes was not originally designed with strong multi-tenancy guarantees.

## DIY Approach

If you can tolerate the weaker multi-tenancy model in exchange for simplicity and convenience, you can roll out your own isolation using native Kubernetes primitives:

- **Namespaces** — Logical isolation for resources
- **RBAC** — Role-Based Access Control for authorization
- **Resource Quotas** — Limit resource consumption per namespace
- **Network Policies** — Control pod-to-pod communication
- **Pod Security Standards** — Enforce security contexts

## Tools for Multi-Tenancy

There are tools that abstract multi-tenancy complexities from you, providing a better developer experience and stronger isolation guarantees:

### Vcluster

[Vcluster](https://www.vcluster.com/) creates virtual Kubernetes clusters that run inside namespaces of a host cluster. Each virtual cluster has its own API server and control plane, providing strong isolation while sharing the underlying infrastructure.

**Key Features:**

- Full Kubernetes API compatibility
- Lightweight virtual clusters
- Tenant isolation with dedicated control planes
- Cost-effective alternative to multiple physical clusters

### Capsule

[Capsule](https://capsule.clastix.io/) implements a multi-tenant and policy-based environment in Kubernetes. It aggregates multiple namespaces into a "Tenant" abstraction, providing isolation and governance.

**Key Features:**

- Hierarchical namespace management
- Native Kubernetes experience for tenants
- Policy enforcement across tenant namespaces
- Resource quota management at tenant level

## Comparison

| Aspect            | DIY (Namespaces + RBAC) | Capsule         | Vcluster             |
|-------------------|-------------------------|-----------------|----------------------|
| Isolation Level   | Soft                    | Soft            | Hard                 |
| Complexity        | Low                     | Medium          | Medium               |
| API Compatibility | Limited                 | Full            | Full                 |
| Control Plane     | Shared                  | Shared          | Dedicated per tenant |
| Use Case          | Trusted teams           | Multi-team orgs | Untrusted tenants    |

## References

- [ADR-EKS-SEC-10002-MULTI-TENANCY](https://github.com/aws-samples/container-design-decisions/blob/main/EKS/Security/ADR-EKS-SEC-10002-MULTI-TENANCY.md)
