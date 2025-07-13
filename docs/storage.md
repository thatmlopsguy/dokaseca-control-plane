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
└────────────────────────────────────────────┘
```

### Installation

To install MinIO using Docker:

```bash
# Create directories for MinIO data
mkdir -p data/minio/velero-dev
mkdir -p data/minio/velero-stg
mkdir -p data/minio/velero-prod
mkdir -p data/minio/loki
mkdir -p data/minio/tempo
mkdir -p data/minio/vm


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
mc mb local/velero-dev
mc mb local/velero-stg
mc mb local/velero-prod
mc mb local/loki
mc mb local/tempo
mc mb local/vm
```

### Bucket Configuration

MinIO is configured with dedicated buckets for each service:

| Service          | Bucket Name  | Purpose                       |
|------------------|--------------|-------------------------------|
| Velero           | velero-{env} | Kubernetes backup and restore |
| Loki             | loki         | Log storage and querying      |
| Tempo            | tempo        | Distributed tracing storage   |
| Victoria Metrics | vm           | Long-term metrics storage     |

## Service Integrations

### Velero Backup and Restore

[Velero](https://velero.io/) uses MinIO for storing Kubernetes cluster backups:

```bash
# Install Velero with MinIO storage
velero install \
  --provider aws \
  --plugins velero/velero-plugin-for-aws:v1.7.0 \
  --bucket velero-dev \
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

## References

- [MinIO Documentation](https://docs.min.io/)
- [Velero with MinIO](https://velero.io/docs/main/contributions/minio/)
- [Loki Storage](https://grafana.com/docs/loki/latest/operations/storage/)
- [Tempo Storage](https://grafana.com/docs/tempo/latest/configuration/s3/)
- [Victoria Metrics Storage](https://docs.victoriametrics.com/Single-server-VictoriaMetrics.html#storage)
