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

## Skupper

Install cli

```sh
$ curl https://skupper.io/install.sh | sh
$ skupper version
client version                 1.8.3
transport version              not-found (no configuration has been provided)
controller version             not-found (no configuration has been provided)
```

## References

- [Kubernetes Multicluster Load Balancing with Skupper](https://piotrminkowski.com/2023/08/04/kubernetes-multicluster-load-balancing-with-skupper/)
- [Building a Bridge between Terraform and ArgoCD](https://www.slideshare.net/CarlosSantana1/building-a-bridge-between-terraform-and-argocd)
