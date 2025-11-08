# Use kube-green for Energy Optimization with ArgoCD Sync Windows

Date: 2025-11-07

## Status

Proposed

## Context

DokaSeca Kubernetes operates 24/7, consuming energy even during periods when development and testing activities are minimal (evenings, weekends, holidays). Many development and preview workloads remain active unnecessarily during these periods, leading to:

- Increased energy consumption and environmental impact
- Higher operational costs
- Inefficient resource utilization
- Carbon footprint concerns in alignment with sustainable cloud computing practices

The CNCF Environmental Sustainability TAG and initiatives like the Green Software Foundation are promoting more sustainable cloud-native practices.

Additionally, there's a fundamental conflict between kube-green (which modifies deployment replicas) and ArgoCD's GitOps reconciliation loop. When kube-green sets replicas to 0, ArgoCD detects this as drift from the desired state in Git and will attempt to restore the original replica count, defeating the energy optimization purpose.

## Decision

We will implement kube-green to automatically scale down Kubernetes deployments to zero replicas during non-working hours, combined with ArgoCD Sync Windows to prevent conflicts during sleep periods.

### Primary Solution: kube-green with ArgoCD Sync Windows

**Implementation approach:**

1. **Deploy kube-green controller** in the cluster with appropriate RBAC permissions
2. **Configure SleepInfo resources** for target namespaces with sleep/wake schedules:
   - Sleep: Weekdays 19:00 - 07:00 (next day)
   - Sleep: Weekends (Friday 19:00 - Monday 07:00)
3. **Implement ArgoCD Sync Windows strategy** (Solution 2 from Akuity blog) rather than ignoreDifferences approach:
   - Configure sync windows that encompass kube-green sleep periods
   - Offset sync windows by 1 minute before/after SleepInfo timeframes
   - Apply to development and staging AppProjects
4. **Target workloads:**
   - Development environment deployments
   - Staging/preview environments
   - Non-critical testing applications
   - **Exclude:** Production workloads, monitoring systems, security tools

**ArgoCD Configuration:**

- Use Sync Windows instead of ignoreDifferences to maintain ability to sync legitimate changes
- Configure manual selective sync capability for emergency changes during sleep periods
- Accept that applications will show as "OutOfSync" during sleep periods

### Alternative Solution: KEDA Cron Scaler

As an alternative to kube-green, KEDA's Cron scaler can achieve similar energy optimization goals with a different approach:

**KEDA Cron Implementation:**

1. **Deploy KEDA operator** in the cluster
2. **Create ScaledObject resources** for each deployment with cron triggers:
   - Set `minReplicaCount: 0` to enable scaling to zero
   - Configure `start: 0 7 * * *` (7:00 AM) and `end: 0 19 * * *` (7:00 PM)
   - Set appropriate timezone (e.g., `timezone: Europe/Lisbon`)
   - Define `desiredReplicas` for working hours
3. **GitOps compatibility**: KEDA modifies HPA resources, not deployment replicas directly
4. **Per-deployment configuration** allows fine-grained control

**Example KEDA ScaledObject:**

```yaml
apiVersion: keda.sh/v1alpha1
kind: ScaledObject
metadata:
  name: dev-app-scaler
  namespace: development
spec:
  scaleTargetRef:
    name: my-dev-app
  minReplicaCount: 0
  cooldownPeriod: 300
  triggers:
    - type: cron
      metadata:
        timezone: Europe/Lisbon
        start: 0 7 * * *    # 7:00 AM
        end: 0 19 * * *     # 7:00 PM
        desiredReplicas: "2"
```

**KEDA vs kube-green comparison:**

| Aspect                 | KEDA Cron                      | kube-green                  |
|------------------------|--------------------------------|-----------------------------|
| ArgoCD Compatibility   | ✅ Better (uses HPA)           | ⚠️ Requires Sync Windows   |
| Granularity            | Per-deployment                 | Namespace-based             |
| Setup Complexity       | Medium (per-deployment config) | Lower (namespace SleepInfo) |
| Scheduling Flexibility | High (cron expressions)        | Medium (time ranges)        |
| GitOps Integration     | Native                         | Requires workarounds        |
| Resource Overhead      | Higher (HPA per deployment)    | Lower (single controller)   |

**Recommendation:** We choose kube-green as the primary solution due to its simplicity and namespace-level configuration, with KEDA Cron as a future alternative for workloads requiring more granular control.

## Consequences

### What becomes easier

- **Reduced energy consumption** during non-working hours (estimated 60-70% reduction for targeted workloads)
- **Lower operational costs** for compute resources
- **Environmental sustainability** alignment with green computing practices
- **Resource optimization** allowing better utilization during working hours
- **Manual wake-up capability** through ArgoCD manual sync if needed during sleep periods

### What becomes more difficult

- **Monitoring complexity** - applications will show as OutOfSync during sleep periods
- **Emergency deployments** require manual selective sync during sleep windows
- **Debugging complexity** - need awareness of sleep schedules when troubleshooting
- **Initial setup overhead** for configuring SleepInfo and Sync Windows
- **Documentation requirements** for team awareness of sleep schedules
- **Coordination needed** between kube-green schedules and ArgoCD sync windows

### Trade-offs accepted

- Applications appearing as OutOfSync during sleep periods (visual noise in ArgoCD UI)
- Need for manual intervention for urgent changes during sleep windows
- Additional operational complexity for the benefit of sustainability

### Risks and mitigations

- **Risk:** Accidental application of sleep schedules to production workloads
  - **Mitigation:** Namespace-based targeting, explicit exclusion lists, thorough testing
- **Risk:** Sync window misconfiguration causing permanent sync prevention
  - **Mitigation:** Regular review of sync windows, monitoring, documentation
- **Risk:** Team confusion about application states during sleep periods
  - **Mitigation:** Training, documentation, ArgoCD notifications/labels

## References

- [Akuity Blog: Sustainable GitOps with Argo CD and kube-green](https://akuity.io/blog/argo-cd-kube-green)
- [kube-green Official Documentation](https://kube-green.dev/)
- [KEDA Cron Scaler Documentation](https://keda.sh/docs/2.15/scalers/cron/#scale-to-0-during-off-hours)
- [CNCF Environmental Sustainability TAG](https://github.com/cncf/tag-env-sustainability)
- [ArgoCD Sync Windows Documentation](https://argo-cd.readthedocs.io/en/stable/user-guide/sync_windows/)
