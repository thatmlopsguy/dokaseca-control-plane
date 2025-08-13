# Cost Management & Sustainability

DoKa Seca provides a comprehensive approach to cost management and environmental sustainability through multiple
integrated tools that help organizations monitor, optimize, and reduce both financial costs and environmental impact
of their Kubernetes infrastructure.

## Cost Visibility with Kubecost

DoKa Seca integrates [Kubecost](https://www.kubecost.com/) (also known as OpenCost) to provide comprehensive cost
visibility and management for Kubernetes workloads. Kubecost offers real-time cost allocation, resource optimization
recommendations, and budget alerts to help teams understand and control their infrastructure spending across the platform.

## Power Efficiency with Kepler

DoKa Seca also integrates with [Kepler](https://sustainable-computing.io/) (Kubernetes-based Efficient Power Level Exporter),
a CNCF project that provides energy consumption monitoring for Kubernetes workloads. Kepler enables organizations to:

- **Monitor Power Consumption**: Track real-time energy usage at the pod, namespace, and cluster level
- **Identify Energy Hotspots**: Discover which workloads consume the most power and optimize accordingly
- **Sustainability Metrics**: Generate reports on carbon footprint and energy efficiency
- **Cost-to-Carbon Correlation**: Understand the relationship between resource costs and environmental impact

Kepler uses eBPF to collect performance counters and system metrics, providing accurate energy consumption data
without requiring additional hardware or modifications to existing workloads.

## Carbon Footprint Reduction with kube-green

To actively reduce the environmental impact of Kubernetes clusters, DoKa Seca integrates [kube-green](https://kube-green.dev/),
an operator specifically designed to reduce CO2 footprint by automatically managing resource lifecycle:

- **Automatic Scaling**: Schedule workloads to scale down during off-hours, weekends, or low-usage periods
- **Resource Hibernation**: Put non-critical workloads to sleep when not needed
- **Smart Scheduling**: Coordinate workload schedules to minimize overall cluster resource usage
- **Policy-Based Management**: Define custom policies for different environments (dev, staging, production)
- **Integration with GitOps**: Manage green policies declaratively through ArgoCD

### Key Benefits

The combination of these tools provides:

- **Financial Optimization**: Reduce infrastructure costs through better resource utilization
- **Environmental Impact**: Lower carbon footprint through efficient power usage and resource management
- **Operational Excellence**: Automated policies reduce manual intervention while maintaining service quality
- **Compliance**: Meet sustainability and ESG (Environmental, Social, Governance) requirements
- **Observability**: Comprehensive metrics and dashboards for both cost and sustainability KPIs

!!! tip "Green Computing Best Practices"
    Combine Kepler's power monitoring with kube-green's scheduling policies to create an intelligent,
    environmentally-conscious platform that automatically optimizes for both cost and carbon footprint.

!!! warning "Warning"
    Detailed configuration documentation coming soon!
