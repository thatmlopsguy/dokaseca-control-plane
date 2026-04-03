# Observability

Continuous Monitoring & Observability increases agility, improves customer experience and reduces risk of the cloud
environment. According to Wikipedia, Observability is a measure of how well internal states of a system can be inferred
from the knowledge of its external outputs.

The difference between Monitoring and Observability is that Monitoring tells you whether a system is working or not,
while Observability tells you why the system isn't working. Monitoring is usually a reactive measure whereas the goal of
Observability is to be able to improve your Key Performance Indicators in a proactive manner. A system cannot be
controlled or optimized unless it is observed. Instrumenting workloads through collection of metrics, logs, or traces
and gaining meaningful insights & detailed context using the right monitoring and observability tools help customers
control and optimize the environment.

## DoKa Seca Observability Stack

DoKa Seca provides a comprehensive observability stack that covers the four pillars of observability: **Metrics**,
**Logs**, **Traces**, **Profiles**.
The platform offers multiple observability solutions that can be enabled based on your requirements.

## Primary Observability Stack

### Victoria Metrics Ecosystem

DoKa Seca's default observability stack is built around the Victoria Metrics ecosystem, providing a high-performance,
cost-effective alternative to Prometheus:

#### **Victoria Metrics K8s Stack** (`enable_victoria_metrics_k8s_stack`)

* **Purpose**: Complete monitoring solution for Kubernetes
* **Components**:
  * Victoria Metrics Single for metrics storage
  * VMAgent for metrics collection
  * VMAlert for alerting
  * VMAlertmanager for alert management
  * Grafana for visualization
* **Features**:
  * PromQL compatibility
  * High compression ratios
  * Multi-tenancy support
  * Long-term storage capabilities

#### **Victoria Logs** (`enable_victoria_logs`)

* **Purpose**: High-performance log management system
* **Features**:
  * LogQL compatibility
  * High compression and query performance
  * Integration with Grafana
  * Cost-effective log storage
* **Components**:
  * Victoria Logs Single server
  * Vector for log collection and shipping
  * Grafana integration for log visualization

#### **Grafana** (Included with VM Stack)

* **Purpose**: Unified visualization and dashboards
* **Features**:
  * Pre-configured dashboards for Kubernetes
  * Victoria Metrics and Victoria Logs datasources
  * Custom dashboard support
  * Alert visualization

### Data Collection and Shipping

#### **Fluent Bit** (`enable_fluent_bit`)

* **Purpose**: Lightweight log forwarder
* **Features**:
  * High-performance log collection
  * Multiple output plugins (Victoria Logs, Elasticsearch, etc.)
  * Kubernetes metadata enrichment
* **Use Case**: Collect application and cluster logs for centralized management

#### **OpenTelemetry Collector** (`enable_opentelemetry_collector`)

* **Purpose**: Unified telemetry data collection
* **Features**:
  * Metrics, logs, and traces collection
  * Data transformation and routing
  * Multi-destination shipping
  * Vendor-agnostic architecture
  * Integration with various backends (Victoria Metrics, Grafana Tempo, Jaeger, etc.)
  * Low resource footprint with auto-scaling capabilities
* **Use Case**: Collect telemetry data from applications and infrastructure for comprehensive observability

## Alternative Observability Solutions

### Prometheus Ecosystem

#### **Kube Prometheus Stack** (`enable_kube_prometheus_stack`)

* **Components**:
  * Prometheus for metrics storage
  * Alertmanager for alert management
  * Grafana for visualization
  * Node Exporter for node metrics
  * Kube State Metrics for Kubernetes metrics
* **Features**:
  * Industry-standard monitoring solution
  * Extensive ecosystem
  * Rich alerting capabilities

#### **Metrics Server** (`enable_metrics_server`)

* **Purpose**: Core resource metrics for Kubernetes
* **Function**: Provides CPU/Memory metrics for HPA and VPA

#### **Prometheus Adapter** (`enable_prometheus_adapter`)

* **Purpose**: Custom metrics API for Kubernetes
* **Function**: Exposes custom metrics for HPA scaling

### Tracing Solutions

#### **Grafana Tempo** (`enable_tempo`)

* **Purpose**: High-scale distributed tracing backend
* **Features**:
  * OpenTelemetry native
  * Object storage backend
  * Grafana integration
  * Cost-effective trace storage

#### **Jaeger** (`enable_jaeger`)

* **Purpose**: End-to-end distributed tracing
* **Components**:
  * Jaeger Agent
  * Jaeger Collector
  * Jaeger Query UI
  * Storage backend

### Profiling Solutions

#### **Pyroscope** (`enable_pyroscope`)

* **Purpose**: Continuous profiling platform
* **Features**:
  * Application performance profiling
  * Resource usage optimization
  * Integration with Grafana
  * Multi-language support

### Specialized Monitoring

#### **OpenTelemetry Operator** (`enable_opentelemetry_operator`)

* **Purpose**: Kubernetes operator for OpenTelemetry
* **Features**:
  * Auto-instrumentation
  * Collector management
  * Custom resource definitions

#### **Grafana Operator** (`enable_grafana_operator`)

* **Purpose**: Kubernetes-native Grafana management
* **Features**:
  * GitOps-friendly dashboard management
  * Multi-tenant Grafana instances
  * Custom resource definitions

#### **K8s Monitoring** (`enable_k8s_monitoring`)

* **Purpose**: Simplified Kubernetes monitoring setup
* **Features**:
  * Pre-configured monitoring stack
  * Best practices implementation
  * Automated discovery

### Service Mesh Observability

#### **Kiali** (`enable_kiali`)

* **Purpose**: Service mesh observability (Istio)
* **Features**:
  * Service topology visualization
  * Traffic flow analysis
  * Configuration validation
  * Performance metrics

#### **Hubble** (`enable_hubble`)

* **Purpose**: Service mesh observability (Cilium)
* **Features**:
  * Network flow visibility
  * Security monitoring
  * Performance metrics

## Dashboard Solutions

### **Headlamp** (`enable_headlamp`)

* **Purpose**: Modern Kubernetes dashboard
* **Features**:
  * Real-time cluster monitoring
  * Resource management
  * Plugin ecosystem

### **Helm Dashboard** (`enable_helm_dashboard`)

* **Purpose**: Web UI for Helm releases
* **Features**:
  * Release management
  * Chart exploration
  * Installation monitoring

### **Altinity Dashboard** (`enable_altinity_dashboard`)

* **Purpose**: ClickHouse cluster monitoring
* **Features**:
  * ClickHouse-specific metrics
  * Query performance monitoring
  * Cluster health visualization

## Configuration Examples

### Enabling Victoria Metrics Stack

```hcl
addons = {
  enable_victoria_metrics_k8s_stack = true
  enable_victoria_logs = true
  enable_alloy = true
}
```

### Enabling Prometheus Stack

```hcl
addons = {
  enable_kube_prometheus_stack = true
  enable_metrics_server = true
  enable_prometheus_adapter = true
}
```

### Enabling Distributed Tracing

```hcl
addons = {
  enable_tempo = true
  enable_opentelemetry_operator = true
  enable_jaeger = true
}
```

## Access Instructions

### Grafana UI

```bash
# For Victoria Metrics stack
kubectl port-forward svc/victoria-metrics-k8s-stack-grafana -n monitoring 3000:80

# For Prometheus stack
kubectl port-forward svc/kube-prometheus-stack-grafana -n monitoring 3000:80

# Get admin password
kubectl get secret -n monitoring <grafana-secret-name> -o jsonpath="{.data.admin-password}" | base64 --decode
```

### Victoria Metrics UI

```bash
kubectl port-forward svc/vmsingle-victoria-metrics-k8s-stack -n monitoring 8429:8429
```

### Victoria Logs UI

```bash
kubectl port-forward svc/victoria-logs-single-server -n monitoring 9428:9428
```

### Prometheus UI

```bash
kubectl port-forward svc/kube-prometheus-stack-prometheus -n monitoring 9090:9090
```

### Jaeger UI

```bash
kubectl port-forward svc/jaeger-query -n monitoring 16686:80
```

DoKa Seca automatically configures ServiceMonitors and dashboards for:

* **ArgoCD**: GitOps metrics and dashboards
* **Kyverno**: Policy enforcement metrics
* **External Secrets**: Secret synchronization metrics
* **Cert-Manager**: Certificate metrics
* **MetalLB**: Load balancer metrics
* **Ingress Controllers**: Traffic metrics

This comprehensive observability stack ensures that your DoKa Seca platform provides deep insights into application and
infrastructure performance, enabling proactive monitoring and troubleshooting capabilities.
