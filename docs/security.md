# Security

The DoKa Seca platform implements a defense-in-depth approach to Kubernetes security, leveraging both vulnerability
scanning and runtime threat detection.

## Trivy: Vulnerability & Misconfiguration Scanning

[Trivy](https://aquasecurity.github.io/trivy/) is used for:

- Scanning container images for vulnerabilities (CVEs)
- Auditing Kubernetes manifests for misconfigurations
- Integrating with CI/CD pipelines for early detection
- Generating `ConfigAuditReports` and `VulnerabilityReports` in-cluster

**Example: Scan a running deployment**

```bash
kubectl create deployment nginx --image nginx:1.16
kubectl get configauditreports -o wide
```

Sample output:

```sh
NAME                          SCANNER   AGE     CRITICAL   HIGH   MEDIUM   LOW
replicaset-nginx-599c4f6679   Trivy     3m16s   0          2      3        10
```

**Trivy is integrated via the [KubeSec Operator](https://github.com/aquasecurity/trivy-operator) for continuous cluster scanning.**

## Falco: Runtime Threat Detection

[Falco](https://falco.org/) is used for:

- Real-time detection of suspicious activity in Kubernetes nodes and containers
- Alerting on unexpected process execution, file access, privilege escalation, and network activity
- Enforcing runtime security policies with custom rules
- Integrating with alerting systems (Slack, Prometheus, etc)

### Example: View Falco alerts

```bash
kubectl logs -n falco -l app=falco
```

**Common Falco rules include:**

- Detecting shell in a container
- Detecting changes to sensitive files
- Detecting privilege escalation attempts

## Security Best Practices

- All images are scanned before deployment
- Cluster is continuously monitored for runtime threats
- Alerts are integrated with platform observability
- Security events are audited and reviewed regularly

## GitHub Actions Security

### Pin Action Versions

All GitHub Actions used in CI/CD workflows **must use pinned versions (commit SHA)** instead of tags or branches to prevent
supply chain attacks. This ensures immutable references to specific action versions.

![github-actions](assets/figures/images/github-policy-actions.png)

**❌ Avoid using tags or branches:**

```yaml
- uses: actions/checkout@v4
- uses: actions/setup-node@main
```

**✅ Use pinned SHA versions:**

```yaml
- uses: actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332  # v4.1.7
- uses: actions/setup-node@60edb5dd545a775178f52524783378180af0d1f8  # v4.0.2
```

**Benefits of pinning:**

- **Immutability**: Actions cannot be modified after deployment
- **Supply Chain Security**: Prevents compromised tags from affecting workflows
- **Reproducibility**: Ensures consistent behavior across workflow runs
- **Audit Trail**: Clear visibility into exact versions being used

**Implementation Guidelines:**

1. Always include version comment for human readability
2. Regularly update pinned versions and review changes
3. Monitor security advisories for actions in use

## References

- [Trivy Documentation](https://aquasecurity.github.io/trivy/)
- [Falco Documentation](https://falco.org/docs/)
- [Kubernetes Security Best Practices](https://kubernetes.io/docs/concepts/security/overview/)
- [GitHub Actions Policy](https://github.blog/changelog/2025-08-15-github-actions-policy-now-supports-blocking-and-sha-pinning-actions/)
