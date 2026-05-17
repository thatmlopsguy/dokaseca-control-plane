# Machine Learning

Doka Seca provides a robust machine learning platform built on Kubernetes, integrating best-in-class tools for
distributed training, LLM request routing, and observability.

## Components Overview

Doka Seca's machine learning stack consists of four core components:

1. **LiteLLM** - For routing LLM requests
2. **Langfuse** or **Langtrace** - For LLM observability
3. **Kubeai/LLMKube** - For LLM inference:
   1. **vllm** - For local LLM inference
   2. **ollama** - For local LLM inference
4. **Kaito** - Operator that automates the AI/ML model inference or tuning workload in a Kubernetes cluster
5. **MLflow** - For experiment tracking and model management

## vllm

[vllm](https://github.com/vllm-project/vllm) is a high-performance LLM inference engine designed for efficient local inference.
Doka Seca utilizes vllm to run large language models locally with optimized resource usage.

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

## Langtrace

[Langtrace](https://docs.langtrace.ai/) is an open-source observability platform for LLM applications, similar to Langfuse.
Doka Seca offers Langtrace as an alternative to Langfuse for users seeking a different set of features or integrations.

## MLflow

[MLflow](https://mlflow.org/) is an open-source platform for managing the end-to-end machine learning lifecycle.
Doka Seca incorporates MLflow for experiment tracking, model versioning, and deployment management.

### MLflow Capabilities

- **Experiment Tracking**: Log parameters, metrics, and artifacts for reproducibility
- **Model Registry**: Centralized repository for managing model versions and stages
- **Deployment**: Seamlessly deploy models to various serving platforms
- **Integration**: Works with popular ML libraries and frameworks

## References

- [Ray Documentation](https://docs.ray.io/en/latest/)
- [LiteLLM GitHub Repository](https://github.com/BerriAI/litellm)
- [Langfuse Documentation](https://docs.langfuse.com/)
- [Open Source LLMOps Stack](https://oss-llmops-stack.com/)
- [MLflow Documentation](https://mlflow.org/docs/latest/index.html)
- [Langtrace Documentation](https://docs.langtrace.ai/)
- [LLMKube Documentation](https://llmkube.com/docs)
- [KubeAI Documentation](https://www.kubeai.org/)
- [Kaito Documentation](https://kaito-project.github.io/kaito/docs/)
