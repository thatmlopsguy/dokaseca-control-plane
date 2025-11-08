# Visualization and Dashboards

DoKa Seca provides unified observability visualization through **Grafana**, serving as the central platform for monitoring logs, metrics, and traces across your Kubernetes infrastructure. Grafana acts as the single pane of glass for all observability data, providing comprehensive dashboards, alerting, and analysis capabilities.

## Grafana: The Central Visualization Platform

**Grafana** is DoKa Seca's primary visualization platform, automatically configured and integrated with all observability backends to provide seamless data correlation and analysis.

### Default Grafana Integration

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│ Victoria Metrics│───▶│                  │    │                 │
│  (Metrics)      │    │                  │    │   Dashboards    │
├─────────────────┤    │     Grafana      │───▶│   & Alerts      │
│ Victoria Logs   │───▶│   (Central Hub)  │    │                 │
│   (Logs)        │    │                  │    │                 │
├─────────────────┤    │                  │    │                 │
│     Tempo       │───▶│                  │    │                 │
│   (Traces)      │    └──────────────────┘    └─────────────────┘
└─────────────────┘
```

### Grafana Configuration

Grafana is automatically deployed and configured when you enable the observability stack:

```hcl
# Basic Grafana deployment with observability stack
addons = {
  enable_victoria_metrics_k8s_stack = true  # Includes Grafana
  enable_victoria_logs = true               # Auto-configured datasource
  enable_tempo = true                       # Auto-configured datasource
}
```

### Accessing Grafana

```bash
# Port forward to Grafana
kubectl port-forward svc/victoria-metrics-k8s-stack-grafana -n monitoring 3000:80

# Get admin password
kubectl get secret -n monitoring victoria-metrics-k8s-stack-grafana \
  -o jsonpath="{.data.admin-password}" | base64 --decode

# Default credentials
# Username: admin
# Password: [decoded from secret above]
```

## Metrics Visualization

DoKa Seca automatically configures Grafana with comprehensive metrics dashboards for infrastructure and application monitoring.

### Default Metrics Datasources

#### Victoria Metrics Datasource

```yaml
# Automatically configured datasource
apiVersion: 1
datasources:
  - name: VictoriaMetrics
    type: prometheus
    url: http://vmsingle-victoria-metrics-k8s-stack:8429
    access: proxy
    isDefault: true
    jsonData:
      httpMethod: POST
      timeInterval: 30s
```

#### Prometheus Datasource (Alternative)

```yaml
# When using Prometheus stack
datasources:
  - name: Prometheus
    type: prometheus
    url: http://kube-prometheus-stack-prometheus:9090
    access: proxy
    isDefault: true
```

### Pre-built Metrics Dashboards

DoKa Seca includes comprehensive pre-configured dashboards:

#### **Kubernetes Cluster Overview**

- Cluster resource utilization (CPU, Memory, Storage)
- Node health and capacity
- Pod distribution and status
- Network traffic patterns

#### **Application Performance Monitoring**

- Application response times and throughput
- Error rates and success rates
- Custom business metrics
- SLA/SLO tracking

#### **Infrastructure Monitoring**

- Node exporter metrics
- Container runtime metrics
- Storage performance
- Network performance

#### **ArgoCD GitOps Dashboard**

- Application sync status
- Deployment frequency
- Sync performance metrics
- Git repository health

## Logs Visualization

Grafana provides powerful log analysis capabilities through integration with Victoria Logs and other log backends.

### Logs Datasource Configuration

#### Victoria Logs Datasource

```yaml
# Automatically configured for Victoria Logs
datasources:
  - name: VictoriaLogs
    type: loki
    url: http://victoria-logs-single-server:9428
    access: proxy
```

## Traces Visualization

Grafana provides comprehensive trace analysis capabilities through integration with Tempo, Jaeger, and other tracing backends.

### Traces Datasource Configuration

#### Tempo Datasource

```yaml
# Automatically configured Tempo datasource
datasources:
  - name: Tempo
    type: tempo
    url: http://tempo-query-frontend:3200
    access: proxy
```

#### Jaeger Datasource (Alternative)

```yaml
# When using Jaeger
datasources:
  - name: Jaeger
    type: jaeger
    url: http://jaeger-query:16686
    access: proxy
```
