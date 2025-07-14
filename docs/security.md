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

## References

- [Trivy Documentation](https://aquasecurity.github.io/trivy/)
- [Falco Documentation](https://falco.org/docs/)
- [Kubernetes Security Best Practices](https://kubernetes.io/docs/concepts/security/overview/)
