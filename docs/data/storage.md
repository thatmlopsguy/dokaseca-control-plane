# Storage

This document describes the storage architecture used in the DoKa Seca, focusing on how MinIO running in Docker is used
to provide S3-compatible object storage for various components.

## MinIO Object Storage

[MinIO](https://min.io/) is a high-performance, S3-compatible object storage system that we deploy to provide persistent
storage for several critical components.

### Architecture

We run MinIO as a Docker container outside the Kubernetes cluster, providing S3-compatible storage that our Kubernetes services connect to:

```ascii
┌─────────────────┐           ┌───────────────────────────┐
│ Docker Host     │           │ Kubernetes Cluster        │
│                 │           │                           │
│ ┌─────────────┐ │  access   │  ┌─────────┐ ┌─────────┐  │
│ │ MinIO Server│◄├───────────┤►◄│ Service │ │ Service │  │
│ └─────────────┘ │           │  └─────────┘ └─────────┘  │
└─────────────────┘           └───────────────────────────┘
        │
        ▼
┌────────────────────────────────────────────┐
│             S3 Buckets                     │
│                                            │
│  ┌──────────┐ ┌───────┐ ┌───────┐ ┌──────┐ │
│  │  velero  │ │ loki  │ │ tempo │ │  vm  │ │
│  └──────────┘ └───────┘ └───────┘ └──────┘ │
│  ┌───────────────┐                         │
│  │ report-portal │                         │
│  └───────────────┘                         │
└────────────────────────────────────────────┘
```

### Installation

To install MinIO using Docker:

```bash
# Create directories for MinIO data
mkdir -p data/minio/velero
mkdir -p data/minio/loki
mkdir -p data/minio/tempo
mkdir -p data/minio/victoriametrics
mkdir -p data/minio/victoriatraces
mkdir -p data/minio/victorialogs
mkdir -p data/minio/reportportal
mkdir -p data/minio/mlflow
mkdir -p data/minio/langfuse
mkdir -p data/minio/pyroscope
mkdir -p data/minio/harbor
mkdir -p data/minio/chartmuseum
mkdir -p data/minio/argoworkflows
mkdir -p data/minio/falcosidekick

# Start MinIO
docker compose up -d
```

This will start a MinIO server accessible at:

- API endpoint: `http://localhost:9000` (for S3 clients)
- Web Console: `http://localhost:9001` (for administration)

### Creating Buckets

After installation, create the required buckets:

```bash
# Install MinIO client
curl https://dl.min.io/client/mc/release/linux-amd64/mc \
  --create-dirs \
  -o $HOME/bin/mc && \
  chmod +x $HOME/bin/mc

# Configure MinIO client
mc alias set local http://localhost:9000 minioadmin minioadmin

# Create buckets
mc mb local/velero
mc mb local/loki
mc mb local/tempo
mc mb local/victoriametrics
mc mb local/victoriatraces
mc mb local/victorialogs
mc mb local/reportportal
mc mb local/mlflow
mc mb local/langfuse
mc mb local/pyroscope
mc mb local/harbor
mc mb local/chartmuseum
mc mb local/argoworkflows
mc mb local/falcosidekick

### Bucket Configuration

MinIO is configured with dedicated buckets for each service:

| Service          | Bucket Name     | Purpose                           |
|------------------|-----------------|-----------------------------------|
| Velero           | velero          | Kubernetes backup and restore     |
| Loki             | loki            | Log storage and querying          |
| Tempo            | tempo           | Distributed tracing storage       |
| Victoria Metrics | victoriametrics | Long-term metrics storage         |
| Victoria Traces  | victoriatraces  | Long-term traces storage          |
| Victoria Logs    | victorialogs    | Long-term logs storage            |
| ReportPortal     | reportportal    | Object storage for ReportPortal   |
| MLflow           | mlflow          | Object storage for MLflow         |
| Langfuse         | langfuse        | Object storage for Langfuse       |
| Pyroscope        | pyroscope       | Object storage for Pyroscope      |
| Harbor           | harbor          | Object storage for Harbor         |
| ChartMuseum      | chartmuseum     | Object storage for ChartMuseum    |
| Argo Workflows   | argoworkflows   | Object storage for Argo Workflows |
| Falco Sidekick   | falcosidekick   | Object storage for Falco Sidekick |

## Service Integrations

### Velero Backup and Restore

[Velero](https://velero.io/) uses MinIO for storing Kubernetes cluster backups:

```bash
# Install Velero with MinIO storage
velero install \
  --provider aws \
  --plugins velero/velero-plugin-for-aws:v1.7.0 \
  --bucket velero \
  --secret-file ./credentials-velero \
  --use-volume-snapshots=false \
  --backup-location-config region=minio,s3ForcePathStyle="true",s3Url=http://<docker-host-ip>:9000
```

### Loki Log Storage

[Loki](https://grafana.com/oss/loki/) is configured to use MinIO for persistent log storage:

```yaml
loki:
  storage:
    bucketNames:
      chunks: loki
      ruler: loki
      admin: loki
    type: s3
    s3:
      endpoint: <docker-host-ip>:9000
      region: minio
      secretAccessKey: minioadmin
      accessKeyId: minioadmin
      s3ForcePathStyle: true
      insecure: true
```

### Tempo Tracing Backend

[Tempo](https://grafana.com/oss/tempo/) uses MinIO for storing distributed traces:

```yaml
tempo:
  storage:
    trace:
      backend: s3
      s3:
        endpoint: <docker-host-ip>:9000
        bucket: tempo
        access_key: minioadmin
        secret_key: minioadmin
        insecure: true
```

### Victoria Metrics Long-term Storage

[Victoria Metrics](https://victoriametrics.com/) uses MinIO for long-term metrics storage:

```yaml
vmstorage:
  persistentVolume:
    enabled: true
  extraArgs:
    storageDataPath: "/storage"
    retentionPeriod: "3m"
  s3:
    enabled: true
    endpoint: "http://<docker-host-ip>:9000"
    bucket: "vm"
    accessKey: "minioadmin"
    secretKey: "minioadmin"
    region: "minio"
```

## ReportPortal Dependencies

ReportPortal relies on MinIO for object storage. You can deploy MinIO manually as described earlier in this document or use a cloud-based alternative like AWS S3 or Azure Blob Storage.

Example configuration for MinIO:

```yaml
reportportal:
  objectStorage:
    endpoint: <your-minio-endpoint>
    accessKey: <your-access-key>
    secretKey: <your-secret-key>
    bucket: <your-bucket-name>
```

## References

- [MinIO Documentation](https://docs.min.io/)
- [Velero with MinIO](https://velero.io/docs/main/contributions/minio/)
- [Loki Storage](https://grafana.com/docs/loki/latest/operations/storage/)
- [Tempo Storage](https://grafana.com/docs/tempo/latest/configuration/s3/)
- [Victoria Metrics Storage](https://docs.victoriametrics.com/Single-server-VictoriaMetrics.html#storage)
- [ReportPortal Object Storage](https://reportportal.io/docs/installation-steps/DeployWithKubernetes#install-the-chart-with-dependencies)
