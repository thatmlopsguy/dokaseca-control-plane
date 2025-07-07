# Architecture Decision Records (ADRs)

This directory contains Architecture Decision Records (ADRs) for the DoKa Seca project.

## What are ADRs?

Architecture Decision Records are short text documents that capture an important architectural decision made along with its context and consequences. They help teams understand why certain decisions were made and provide historical context for future changes.

## ADR List

- [Use Architecture Decision Records](001-use-architecture-decision-records.md)

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
