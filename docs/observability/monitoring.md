# Monitoring and Alerting

DoKa Seca provides comprehensive metrics collection, storage, and alerting capabilities to monitor your Kubernetes infrastructure and applications.
The platform uses a **hub-and-spoke architecture** with **Victoria Metrics** as the default metrics backend and **VMAlert/VMAlertmanager** for alerting.

## Default Monitoring Architecture

The **default and recommended** monitoring solution in DoKa Seca uses **Victoria Metrics** in the central hub cluster
with **VMAgent** in spoke clusters for efficient metrics collection and aggregation.

### Hub-and-Spoke Metrics Architecture

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   Spoke Cluster │    │                  │    │   Hub Cluster   │
│                 │    │                  │    │                 │
│   ┌─────────────┤    │                  │    │ ┌─────────────┐ │
│   │  VMAgent    │───▶│    Network       │───▶│ │  Victoria   │ │
│   │ (Collection)│    │                  │    │ │  Metrics    │ │
│   └─────────────┤    │                  │    │ │ (Storage)   │ │
│                 │    │                  │    │ └─────────────┘ │
└─────────────────┘    └──────────────────┘    │ ┌─────────────┐ │
                                               │ │  VMAlert    │ │
┌─────────────────┐                            │ │ (Alerting)  │ │
│   Spoke Cluster │                            │ └─────────────┘ │
│                 │                            │ ┌─────────────┐ │
│   ┌─────────────┤                            │ │ Grafana     │ │
│   │  VMAgent    │──────────────────────────▶│ │(Visualization)│ │
│   │ (Collection)│                            │ └─────────────┘ │
│   └─────────────┤                            └─────────────────┘
│                 │
└─────────────────┘
```

## Metrics Backends

### 1. Victoria Metrics (Primary/Default)

**Victoria Metrics** is DoKa Seca's **primary and recommended** metrics backend, providing high-performance metrics storage and querying.

#### Victoria Metrics Configuration

```hcl
# Hub cluster configuration
addons = {
  enable_victoria_metrics_k8s_stack = true
}

# Spoke cluster configuration
addons = {
  enable_vmagent = true  # For spoke clusters
}
```

#### Victoria Metrics Features

* **PromQL Compatibility**: Full compatibility with Prometheus query language
* **High Performance**: Optimized for high ingestion rates and fast queries
* **Cost-Effective**: Excellent compression ratios reduce storage costs
* **Long-term Storage**: Efficient storage for metric retention policies
* **Multi-tenancy**: Support for multiple tenants and environments
* **Horizontal Scaling**: Can scale to handle massive metric volumes

#### Victoria Metrics Components

**Hub Cluster Components:**

* **Victoria Metrics Single**: Centralized metrics storage and query engine
* **VMAlert**: Alerting engine compatible with Prometheus alerting rules
* **VMAlertmanager**: Alert management and notification routing
* **Grafana**: Visualization and dashboard platform

**Spoke Cluster Components:**

* **VMAgent**: Lightweight metrics collection and forwarding agent
* **Node Exporter**: System and hardware metrics collection
* **Kube State Metrics**: Kubernetes object state metrics

#### Victoria Metrics Access

```bash
# Victoria Metrics UI (Hub cluster)
kubectl port-forward svc/vmsingle-victoria-metrics-k8s-stack -n monitoring 8429:8429

# VMAgent UI (Spoke cluster)  
kubectl port-forward svc/vmagent-victoria-metrics-k8s-stack -n monitoring 8429:8429

# Grafana (Hub cluster)
kubectl port-forward svc/victoria-metrics-k8s-stack-grafana -n monitoring 3000:80
```

### 2. Prometheus (Alternative)

**Prometheus** provides the industry-standard metrics collection and storage solution.

#### Prometheus Configuration

```hcl
addons = {
  enable_kube_prometheus_stack = true
  enable_metrics_server = true
  enable_prometheus_adapter = true
}
```

#### Prometheus Features

* **Industry Standard**: Widely adopted metrics solution
* **Rich Ecosystem**: Extensive exporter and integration ecosystem
* **Native Alerting**: Built-in alerting with Alertmanager
* **Service Discovery**: Automatic target discovery
* **Recording Rules**: Pre-computed metric aggregations

#### Prometheus Components

* **Prometheus Server**: Metrics storage and query engine
* **Alertmanager**: Alert management and notification
* **Node Exporter**: Node-level metrics
* **Kube State Metrics**: Kubernetes metrics
* **Grafana**: Visualization platform

## Metrics Collection Strategies

### 1. VMAgent Hub-and-Spoke (Recommended)

The **recommended approach** for multi-cluster environments using VMAgent for efficient metrics collection.

#### Hub Cluster Configuration

TODO

#### Spoke Cluster VMAgent Configuration

TODO

### 2. OpenTelemetry Collector Alternative

Use **OpenTelemetry Collector** as an alternative metrics collection method.

#### OTel Collector Metrics Configuration

```hcl
addons = {
  enable_opentelemetry_operator = true
  enable_victoria_metrics_k8s_stack = true  # Hub cluster
}
```

#### OTel Collector Pipeline

TODO

## Alerting with VMAlert and VMAlertmanager

DoKa Seca uses **VMAlert** for alert rule evaluation and **VMAlertmanager** for alert management and notifications.

### VMAlert Configuration

VMAlert is compatible with Prometheus alerting rules and provides enhanced performance.

#### VMAlert Rules

### VMAlertmanager Configuration

VMAlertmanager handles alert routing, grouping, and notifications.

#### Alertmanager Configuration

## Multi-Cluster Monitoring Strategies

### 1. Centralized Hub-and-Spoke (Recommended)

All metrics flow to a central Victoria Metrics instance in the hub cluster.

#### Hub Cluster Setup

```hcl
# Hub cluster - Victoria Metrics stack
addons = {
  enable_victoria_metrics_k8s_stack = true
  enable_grafana_operator = true  # For advanced dashboard management
}
```

#### Spoke Cluster Setup

```hcl
# Spoke clusters - VMAgent only
addons = {
  enable_vmagent = true
  enable_node_exporter = true
  enable_kube_state_metrics = true
}
```

### 2. Federated Monitoring

Each cluster has its own Victoria Metrics instance with federation to the hub.
