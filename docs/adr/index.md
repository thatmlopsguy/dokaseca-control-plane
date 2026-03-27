# Architecture Decision Records (ADRs)

This directory contains Architecture Decision Records (ADRs) for the DoKa Seca project.

## What are ADRs?

Architecture Decision Records are short text documents that capture an important architectural decision made along with its context and consequences. They help teams understand why certain decisions were made and provide historical context for future changes.

## ADR Index

- [Use Architecture Decision Records](001-use-architecture-decision-records.md)
- [External Secrets Operator Multi-tenancy](002-external-secrets-operator-multi-tenancy.md)
- [ArgoCD Hub and Spoke Configuration](003-argocd-hub-and-spoke-configuration.md)
- [Use ArgoCD, vCluster, and GitHub Actions for Preview Environments](004-preview-env-argocd-vcluster.md)
- [Use kube-green for Energy Optimization with ArgoCD Sync Windows](005-kubegreen-energy-optimization.md)

## ADR Template

When creating new ADRs, use the following template:

```markdown
# {title}

Date: {date}

## Status

{status}

## Context

What is the issue that we're seeing that is motivating this decision or change?

## Decision

What is the change that we're proposing and/or doing?

## Consequences

What becomes easier or more difficult to do because of this change?

## References
```

## Guidelines

1. ADRs should be numbered sequentially (001, 002, etc.) in the filename
2. Titles should be descriptive and action-oriented
3. Include the date when the decision was made
4. Keep ADRs concise but complete
5. Update the index when adding new ADRs
6. ADRs are immutable once accepted - create new ADRs to supersede old ones

## Creating ADRs with ADRgen

We recommend using the ADRgen CLI to create new ADRs in this repository. ADRgen is available at `https://github.com/asiermarques/adrgen`.

From the repository root you can create a new ADR in `docs/adr` with:

```bash
adrgen create "Title of the ADR" -m "components, technologies"
```

If you make a decision that improves another previous one, a good practice is specify the relation in both ADR files. For example, if ADR 002 improves ADR 001, you can add a "Supersedes" section in ADR 002 and a "Superseded by" section in ADR 001.

```bash
adrgen create "Another a that improves the previous one" -a 1
```

After creating an ADR, update the index if needed or run `adrgen list` to list ADRs. `adrgen list -f status=accepted` will list only accepted ADRs.
