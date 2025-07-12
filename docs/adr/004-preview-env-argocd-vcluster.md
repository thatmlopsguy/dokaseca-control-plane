# Use ArgoCD, vCluster, and GitHub Actions for Preview Environments

Date: 2025-07-12

## Status

Proposed

## Context

We want to provide on-demand preview environments for every pull request (PR) to improve testing, validation, and feedback cycles. The preview environment should be isolated, ephemeral, and closely match production. Manual setup is slow and error-prone, and static environments are limited and can cause conflicts between PRs.

## Decision

We will use the following approach for preview environments:

- **ArgoCD Pull Request Generator**: Detects new PRs and generates ArgoCD Application manifests for each PR.
- **vCluster**: Each preview environment runs in its own lightweight virtual Kubernetes cluster (vCluster), providing strong isolation and a production-like environment without the overhead of full clusters.
- **GitHub Actions**: Automates the workflow, triggering on PR events to provision the vCluster, deploy the application using ArgoCD, and clean up resources when the PR is closed or merged.

This setup ensures that every PR gets a fresh, isolated environment for testing, and the process is fully automated.

## Consequences

- **Easier to test PRs**: Developers and reviewers can validate changes in a realistic environment before merging.
- **Automated lifecycle**: Environments are created and destroyed automatically, reducing manual work and resource waste.
- **Strong isolation**: vCluster provides isolation between preview environments, reducing conflicts and side effects.
- **Increased resource usage**: Running multiple vClusters may increase resource consumption, so cluster sizing and quotas must be considered.
- **Complexity**: The workflow introduces more moving parts (ArgoCD, vCluster, GitHub Actions), requiring maintenance and monitoring.

## References

- [ArgoCD Pull Request Generator](https://argo-cd.readthedocs.io/en/stable/operator-manual/applicationset/)
- [vCluster](https://www.vcluster.com/)
- [GitHub Actions](https://docs.github.com/en/actions)
