# Profiling Solutions

DoKa Seca supports continuous profiling using **Grafana Pyroscope** for Kubernetes workloads.

## Default Profiling Stack

The default profiling option is **Pyroscope** integrated with **Grafana**.
With Pyroscope enabled, teams can analyze CPU and memory behavior over time and correlate profiles with logs, metrics,
and traces through Grafana.

### 1. Grafana Pyroscope (Supported)

**Pyroscope** is the supported continuous profiling backend in DoKa Seca.

To enable Pyroscope in DoKa Seca:

```hcl
addons = {
  enable_pyroscope = true
}
```

#### Features

* **Continuous Profiling**: Always-on profile collection for application runtime analysis
* **Grafana Integration**: Native visualization and exploration in Grafana
* **Performance Optimization**: Identify hot paths and inefficient code sections
* **Resource Insight**: Understand CPU and memory usage patterns over time
* **Multi-language Support**: Works with multiple language runtimes through profiling SDKs and exporters

#### Access

```bash
# Access Pyroscope through Grafana
kubectl port-forward svc/victoria-metrics-k8s-stack-grafana -n monitoring 3000:80
```

## When To Use Profiling

Use Pyroscope in DoKa Seca when you need to:

* Investigate high CPU or memory consumption
* Detect regressions after application releases
* Optimize expensive functions and request paths
* Correlate profiling data with existing observability signals
