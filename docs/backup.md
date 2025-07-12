# Backup

## Velero: Kubernetes Backup & Restore

[Velero](https://velero.io/) is an open source tool to back up and restore Kubernetes cluster resources and persistent volumes.
It supports public cloud platforms and on-premises environments.

### Key Features

- Take scheduled or on-demand backups of your cluster and restore in case of loss
- Migrate cluster resources to other clusters
- Replicate production clusters to development/testing
- Back up both Kubernetes resources and persistent volumes

---

## Installation

### CLI

Install the Velero CLI:

```bash
curl -L https://github.com/vmware-tanzu/velero/releases/latest/download/velero-linux-amd64.tar.gz | tar -xz
sudo mv velero-linux-amd64/velero /usr/local/bin/
```

### Helm (Recommended)

```bash
helm repo add vmware-tanzu https://vmware-tanzu.github.io/helm-charts
helm repo update
```

---

## Storage Configuration

Velero supports S3-compatible storage (AWS S3, MinIO, etc). Example: MinIO (self-hosted S3):

1. Deploy MinIO
2. Create a bucket for Velero backups
3. Create a Kubernetes secret with your S3 credentials:

```bash
kubectl create secret generic velero-creds \
  --namespace velero \
  --from-literal=aws_access_key_id=<MINIO_ACCESS_KEY> \
  --from-literal=aws_secret_access_key=<MINIO_SECRET_KEY>
```

1. Install Velero with Helm:

```bash
helm install velero vmware-tanzu/velero \
  --namespace velero --create-namespace \
  --set configuration.provider=aws \
  --set configuration.backupStorageLocation.name=default \
  --set configuration.backupStorageLocation.bucket=<YOUR_BUCKET> \
  --set configuration.backupStorageLocation.config.region=minio \
  --set configuration.backupStorageLocation.config.s3ForcePathStyle=true \
  --set configuration.backupStorageLocation.config.s3Url=http://minio.minio.svc:9000 \
  --set credentials.existingSecret=velero-creds
```

---

## Usage

### Create a Backup

```bash
velero backup create my-backup --include-namespaces my-namespace
```

### List Backups

```bash
velero backup get
```

### Restore from Backup

```bash
velero restore create --from-backup my-backup
```

### Schedule Regular Backups

```bash
velero schedule create daily-backup --schedule="0 2 * * *" --include-namespaces my-namespace
```

## References

- [Velero Documentation](https://velero.io/docs/)
