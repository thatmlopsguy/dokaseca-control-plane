# Machine Learning

Doka Seca provides a robust machine learning platform built on Kubernetes, integrating best-in-class tools for distributed training, LLM request routing, and observability.

## Components Overview

Doka Seca's machine learning stack consists of three core components:

1. **Ray Operator** - For distributed training workloads
2. **LiteLLM** - For routing LLM requests
3. **Langfuse** - For LLM observability

## Ray Operator

[Ray](https://ray.io/) is an open-source unified framework for scaling AI and Python applications. Doka Seca leverages the [Ray Operator for Kubernetes](https://docs.ray.io/en/latest/cluster/kubernetes/index.html) to manage distributed training workloads.

### Ray Capabilities

- **Distributed Training**: Scale machine learning workloads across multiple nodes
- **Resource Management**: Efficiently allocate CPU, GPU, and memory resources
- **Fault Tolerance**: Automatically recover from node failures
- **Dynamic Scaling**: Scale resources up or down based on workload demands

### Usage

```yaml
apiVersion: ray.io/v1
kind: RayCluster
metadata:
  name: ray-cluster
spec:
  rayVersion: '2.9.0'
  headGroupSpec:
    rayStartParams: {}
    template:
      spec:
        containers:
        - name: ray-head
          image: rayproject/ray:2.9.0
          resources:
            limits:
              cpu: "2"
              memory: "4Gi"
  workerGroupSpecs:
  - groupName: worker-group
    replicas: 3
    rayStartParams: {}
    template:
      spec:
        containers:
        - name: ray-worker
          image: rayproject/ray:2.9.0
          resources:
            limits:
              cpu: "1"
              memory: "2Gi"
```

## LiteLLM

[LiteLLM](https://github.com/BerriAI/litellm) provides a unified interface for working with various LLM providers.
Doka Seca uses LiteLLM to standardize API calls across different LLM services and implement intelligent request routing.

### LiteLLM Capabilities

- **Provider Agnostic**: Seamless switching between OpenAI, Anthropic, HuggingFace, and other LLM providers
- **Load Balancing**: Distribute requests across multiple models and providers
- **Fallbacks**: Automatically retry failed requests with alternative models
- **Cost Management**: Track and optimize LLM usage costs

### Configuration

LiteLLM is deployed as a proxy service in Kubernetes:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: litellm-proxy
spec:
  replicas: 3
  selector:
    matchLabels:
      app: litellm-proxy
  template:
    metadata:
      labels:
        app: litellm-proxy
    spec:
      containers:
      - name: litellm
        image: ghcr.io/berriai/litellm:main
        ports:
        - containerPort: 8000
        env:
        - name: LITELLM_CONFIG_PATH
          value: "/config/litellm.yaml"
        volumeMounts:
        - name: config
          mountPath: /config
      volumes:
      - name: config
        configMap:
          name: litellm-config
```

## Langfuse

[Langfuse](https://langfuse.com/) is an open-source observability and analytics platform for LLM applications.
Doka Seca integrates Langfuse to provide comprehensive monitoring and tracing of LLM requests.

### Langfuse Capabilities

- **Request Tracing**: Track the flow of requests through your LLM application
- **Performance Monitoring**: Measure latency, token usage, and cost metrics
- **Quality Evaluation**: Evaluate responses against defined criteria
- **Analytics Dashboard**: Visualize patterns and identify optimization opportunities

## References

- [Ray Documentation](https://docs.ray.io/en/latest/)
- [LiteLLM GitHub Repository](https://github.com/BerriAI/litellm)
- [Langfuse Documentation](https://docs.langfuse.com/)
- [Open Source LLMOps Stack](https://oss-llmops-stack.com/)
