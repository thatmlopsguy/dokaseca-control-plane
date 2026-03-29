# Kubernetes Service Checklist

##

- [ ] Prevent unwanted access to the API server
- [ ] Maintain kubernetes version up to date
- [ ] Policy blocking the deployment of vulnerable images
- [ ] Use Secret Stores for sensitive data
- [ ] Use Network Policies to restrict traffic between pods
- [ ] Use Pod Security Policies to restrict pod permissions
- [ ] Sizing of the nodes
- [ ] Enforce Resource Quotas to limit resource usage
- [ ] Namespaces should have LimitRanges to set default resource requests and limits. Use an admission controller like Kyverno to enforce this.
- [ ] Don't use the default namespace
- [ ] Set memory limits and requests for all containers
- [ ] Use a service mesh for observability and security
- [ ] Implement autoscaling of your applications (Horizontal pod autoscaler, KEDA)
- [ ] Use Pod Disruption Budgets to ensure availability during maintenance
- [ ] Use Readiness and Liveness Probes to monitor application health
- [ ] Use Namespaces to isolate resources and manage access control
- [ ] Separate applications from the control plane nodes
- [ ] Use a private registry for your images
- [ ] Use GitOps to deploy workloads in your cluster
- [ ] Schedule and perform Disaster Recovery tests regularly (whitespace deployment)
- [ ] Avoid Pods being placed into a single node, use anti-affinity rules to spread them across the cluster
- [ ] Run more than one replica for your Deployments to ensure high availability
- [ ] Use progressive delivery techniques (canary, blue-green) to minimize the blast radius of failed deployments
- [ ] Prefer distroless images to minimize the attack surface of your workloads

## References

- [Checklist for Kubernetes in Production: Best Practices for SREs](https://www.infoq.com/articles/checklist-kubernetes-production/)
- [The AKS Checklist](https://www.the-aks-checklist.com/)
