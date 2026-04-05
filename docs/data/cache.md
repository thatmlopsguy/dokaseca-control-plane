# Cache & Key-Value Stores for DoKa Seca Platform Services (Redis / Valkey)

This document describes the supported caching and key-value store options in DoKa Seca.

DoKa Seca supports Redis/Valkey for caching, session storage, and lightweight key-value needs.
Some addons (for example, `langfuse`) may use Redis/Valkey for pub/sub, ephemeral storage, or to back small queues.

## Supported Use Cases

- Caching (application-level caches, response caching)
- Session storage
- Pub/Sub and lightweight message passing for addons (e.g. Langfuse instrumentation)
- Feature flags and small metadata stores

## Services that require Redis

| Service  | Purpose of Redis                                                                   |
|----------|------------------------------------------------------------------------------------|
| Langfuse | Pub/Sub, ephemeral queues, and worker coordination for instrumentation and addons  |
| LiteLLM  | Caching and lightweight coordination for model runners (used by some integrations) |
| Airflow  | Celery Redis broker/backend for task queues and scheduler coordination             |
| Dagster  | Redis broker/backend for task queues and scheduler coordination                    |
| Superset | Caching and session storage for improved performance and user experience           |
| Harbor   | Caching and session storage for improved performance and user experience           |
| Uptrace  | Caching and lightweight coordination for distributed tracing and observability     |
| Feast    | Caching and lightweight coordination for feature store operations                  |
