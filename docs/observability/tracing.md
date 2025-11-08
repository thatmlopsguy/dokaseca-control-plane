# Tracing Solutions

DoKa Seca provides comprehensive distributed tracing solutions to monitor and analyze request flows across microservices in your Kubernetes clusters. The platform supports multiple tracing backends and collection methods to meet different performance and scalability requirements.

## Default Tracing Architecture

The **default and recommended** tracing solution in DoKa Seca uses **Tempo** as the tracing backend with **OpenTelemetry Collector** for trace collection and processing.

### Default Stack: Tempo + OpenTelemetry Collector

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   Applications  │───▶│  OpenTelemetry   │───▶│     Tempo       │
│   & Services    │    │   Collector      │    │   (Storage)     │
│   (Instrumented)│    │ (Agent/Gateway)  │    │                 │
└─────────────────┘    └──────────────────┘    └─────────────────┘
                                                          │
                                                          ▼
                                               ┌─────────────────┐
                                               │    Grafana      │
                                               │ (Visualization) │
                                               └─────────────────┘
```

## Tracing Backends

### 1. Grafana Tempo (Primary/Default)

**Tempo** is DoKa Seca's **primary and recommended** tracing backend, providing high-scale distributed tracing.

#### Configuration

```hcl
addons = {
  enable_tempo = true
  enable_opentelemetry_operator = true
}
```

#### Features

* **OpenTelemetry Native**: Native support for OpenTelemetry trace formats
* **Object Storage Backend**: Cost-effective storage using S3, GCS, or Azure Blob
* **High Scalability**: Horizontally scalable architecture
* **Grafana Integration**: Seamless integration with Grafana for trace visualization
* **Low Operational Overhead**: Minimal maintenance requirements
* **Multi-Tenancy**: Support for multiple tenants and environments

#### Components

* **Tempo Distributor**: Receives traces and distributes to ingesters
* **Tempo Ingester**: Writes traces to storage
* **Tempo Querier**: Handles trace queries
* **Tempo Query Frontend**: Query optimization and caching
* **Grafana Datasource**: Automatic Grafana configuration

#### Access

```bash
# Tempo is accessed through Grafana
kubectl port-forward svc/victoria-metrics-k8s-stack-grafana -n monitoring 3000:80

# Direct Tempo API access (for debugging)
kubectl port-forward svc/tempo-query-frontend -n monitoring 3200:3200
```

### 2. Jaeger (Alternative)

**Jaeger** provides end-to-end distributed tracing with a comprehensive UI.

#### Jaeger Configuration

```hcl
addons = {
  enable_jaeger = true
  enable_opentelemetry_operator = true
}
```

#### Jaeger Features

* **Complete Tracing Solution**: All-in-one tracing platform
* **Native UI**: Dedicated Jaeger Query UI for trace analysis
* **Service Dependency Analysis**: Automatic service dependency mapping
* **Performance Analysis**: Built-in performance metrics and analysis
* **Sampling Strategies**: Configurable sampling for cost control
* **Multiple Storage Options**: Elasticsearch, Cassandra, Kafka support

#### Jaeger Components

* **Jaeger Agent**: Collects traces from applications
* **Jaeger Collector**: Processes and stores traces
* **Jaeger Query**: Query service for trace retrieval
* **Jaeger UI**: Web interface for trace visualization
* **Storage Backend**: Configurable storage (Elasticsearch, etc.)

#### Jaeger Access

```bash
# Jaeger UI
kubectl port-forward svc/jaeger-query -n monitoring 16686:80
```

### 3. Zipkin (Lightweight Alternative)

**Zipkin** provides a simple, lightweight distributed tracing system.

#### Zipkin Configuration

```hcl
addons = {
  enable_zipkin = true
}
```

#### Zipkin Features

* **Simple Deployment**: Easy to deploy and configure
* **Web UI**: Built-in web interface for trace visualization
* **Service Discovery**: Automatic service dependency mapping
* **Low Resource Usage**: Minimal resource requirements
* **Multiple Transports**: HTTP, Kafka, RabbitMQ support
* **Storage Flexibility**: In-memory, MySQL, Cassandra, Elasticsearch

#### Zipkin Components

* **Zipkin Collector**: Receives and processes traces
* **Zipkin Storage**: Configurable storage backend
* **Zipkin Query API**: REST API for trace queries
* **Zipkin UI**: Web interface for trace analysis

### 4. Victoria Traces (High-Performance Alternative)

**Victoria Traces** provides high-performance tracing storage compatible with Victoria Metrics ecosystem.

#### Victoria Traces Configuration

```hcl
addons = {
  enable_victoria_traces = true  # When available
  enable_opentelemetry_operator = true
}
```

#### Victoria Traces Features

* **High Performance**: Optimized for high ingestion rates
* **Victoria Metrics Integration**: Seamless integration with VM ecosystem
* **Cost-Effective**: Excellent compression and storage efficiency
* **PromQL Compatibility**: Query traces using familiar syntax
* **Long-term Storage**: Efficient storage for trace retention

## Trace Collection and Processing

### 1. OpenTelemetry Collector (Recommended)

The **OpenTelemetry Collector** is the recommended method for collecting and processing traces.

#### OTel Collector Configuration

```hcl
addons = {
  enable_opentelemetry_operator = true
  enable_tempo = true
}
```

#### OTel Collector Features

* **Vendor Neutral**: Standard OpenTelemetry implementation
* **Flexible Processing**: Rich pipeline for trace processing
* **Multi-Backend**: Send traces to multiple destinations
* **Auto-Instrumentation**: Automatic application instrumentation
* **Resource Attribution**: Kubernetes resource metadata injection

#### OTel Collector Components

* **OpenTelemetry Operator**: Kubernetes operator for managing collectors
* **Collector DaemonSet**: Node-level trace collection
* **Collector Deployment**: Centralized trace processing
* **Instrumentation CRDs**: Auto-instrumentation configuration

#### OpenTelemetry Collector Pipeline

```yaml
apiVersion: opentelemetry.io/v1alpha1
kind: OpenTelemetryCollector
metadata:
  name: trace-collector
spec:
  config: |
    receivers:
      otlp:
        protocols:
          grpc:
            endpoint: 0.0.0.0:4317
          http:
            endpoint: 0.0.0.0:4318
      jaeger:
        protocols:
          grpc:
            endpoint: 0.0.0.0:14250
          thrift_http:
            endpoint: 0.0.0.0:14268
      zipkin:
        endpoint: 0.0.0.0:9411

    processors:
      batch:
        timeout: 1s
        send_batch_size: 1024

      k8sattributes:
        extract:
          metadata:
            - k8s.pod.name
            - k8s.namespace.name
            - k8s.deployment.name
            - k8s.service.name

      resource:
        attributes:
          - key: cluster.name
            value: "production"
            action: insert

    exporters:
      otlp/tempo:
        endpoint: "http://tempo-distributor:4317"
        tls:
          insecure: true

      jaeger/jaeger:
        endpoint: "jaeger-collector:14250"
        tls:
          insecure: true

    service:
      pipelines:
        traces:
          receivers: [otlp, jaeger, zipkin]
          processors: [k8sattributes, resource, batch]
          exporters: [otlp/tempo]
```

### 2. Auto-Instrumentation

OpenTelemetry provides automatic instrumentation for various programming languages.

#### Auto-Instrumentation Configuration

```yaml
apiVersion: opentelemetry.io/v1alpha1
kind: Instrumentation
metadata:
  name: default-instrumentation
spec:
  exporter:
    endpoint: http://otel-collector:4317

  propagators:
    - tracecontext
    - baggage
    - b3

  sampler:
    type: parentbased_traceidratio
    argument: "0.1"  # 10% sampling rate

  java:
    image: ghcr.io/open-telemetry/opentelemetry-operator/autoinstrumentation-java:latest

  nodejs:
    image: ghcr.io/open-telemetry/opentelemetry-operator/autoinstrumentation-nodejs:latest

  python:
    image: ghcr.io/open-telemetry/opentelemetry-operator/autoinstrumentation-python:latest

  dotnet:
    image: ghcr.io/open-telemetry/opentelemetry-operator/autoinstrumentation-dotnet:latest
```

#### Application Annotation for Auto-Instrumentation

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: sample-app
spec:
  template:
    metadata:
      annotations:
        instrumentation.opentelemetry.io/inject-java: "default-instrumentation"
        instrumentation.opentelemetry.io/inject-nodejs: "default-instrumentation"
        instrumentation.opentelemetry.io/inject-python: "default-instrumentation"
    spec:
      containers:
      - name: app
        image: sample-app:latest
```

## Tracing Architecture Patterns

### 1. Default Pattern (Recommended)

Use Tempo with OpenTelemetry Collector for most use cases:

```hcl
addons = {
  enable_tempo = true
  enable_opentelemetry_operator = true
  enable_victoria_metrics_k8s_stack = true  # For Grafana integration
}
```

### 2. Jaeger-Centric Pattern

Use Jaeger for environments requiring native Jaeger UI:

```hcl
addons = {
  enable_jaeger = true
  enable_opentelemetry_operator = true
}
```

### 3. Multi-Backend Pattern

Send traces to multiple backends for different purposes:

```hcl
addons = {
  enable_tempo = true              # Primary trace storage
  enable_jaeger = true             # For Jaeger-specific analysis
  enable_opentelemetry_operator = true
}
```

### 4. High-Performance Pattern

Use Victoria Traces for high-volume environments:

```hcl
addons = {
  enable_victoria_traces = true
  enable_victoria_metrics_k8s_stack = true
  enable_opentelemetry_operator = true
}
```

## Trace Visualization and Analysis

### Grafana Integration

All tracing backends integrate with Grafana for unified observability.

### Service Maps and Dependencies

Grafana automatically generates service dependency maps from trace data:

* **Service Topology**: Visual representation of service interactions
* **Latency Analysis**: Per-service and inter-service latency metrics
* **Error Propagation**: Error flow analysis across services
* **Traffic Patterns**: Request volume and patterns visualization

## Sampling Strategies

### 1. Probabilistic Sampling

```yaml
# Basic probabilistic sampling
sampler:
  type: probabilistic
  argument: "0.1"  # 10% of traces
```

### 2. Adaptive Sampling

TODO

### 3. Tail-Based Sampling

TODO
