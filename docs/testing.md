# Testing in Doka Seca

## Overview

Doka Seca self-hosts a Report Portal Helm chart to provide a centralized platform for visualizing and managing test results from all teams. This ensures transparency, collaboration, and efficient debugging across the organization.

## Report Portal

### Purpose

Report Portal is used to aggregate and display test results from various teams. It supports:

- Centralized test result storage
- Real-time reporting
- Historical data analysis
- Integration with CI/CD pipelines

### Deployment

The Report Portal Helm chart is deployed in the Kubernetes cluster managed by Doka Seca. It is configured to:

- Use persistent storage for test data
- Integrate with authentication mechanisms for secure access
- Provide dashboards for test result visualization

### Access

Teams can access the Report Portal via the following URL:

```
https://report-portal.dokaseca.local
```

### Configuration

The Helm chart is configured with the following values:

- `persistence.enabled`: true
- `resources.requests.cpu`: "500m"
- `resources.requests.memory`: "512Mi"
- `ingress.enabled`: true
- `ingress.hosts`: ["report-portal.dokaseca.local"]

### Usage

1. Teams push their test results to the Report Portal using the provided API.
2. Dashboards and reports can be customized per team.
3. Historical data can be queried for trend analysis.

For more details, refer to the [Report Portal documentation](https://reportportal.io/).
