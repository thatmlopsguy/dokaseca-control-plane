# Runbook: Velero Backup FailedValidation — Missing `cloud` Credentials Key

## Summary

Velero backups report `FailedValidation` status and the `BackupStorageLocation` is marked
`Unavailable` because the credentials Secret is missing the required `cloud` key expected
by the Velero AWS plugin.

---

## Symptoms

```
NAME        STATUS             ERRORS   WARNINGS   CREATED   EXPIRES   STORAGE LOCATION   SELECTOR
my-backup   FailedValidation   0        0          <nil>     29d       default            <none>
```

Velero controller logs contain:

```
level=error msg="Error getting a backup store"
  backup-storage-location=velero/default
  error="unable to get credentials: unable to get key for secret:
         \"velero-s3-credentials\" secret is missing data for key \"cloud\""
```

```
level=error msg="Current BackupStorageLocations available/unavailable/unknown: 0/1/0,
  BackupStorageLocation \"default\" is unavailable: unable to get credentials:
  unable to get key for secret: \"velero-s3-credentials\" secret is missing data for key \"cloud\""
```

---

## Root Cause

The Velero AWS plugin reads S3 credentials from a Secret key named `cloud`, which must
contain an INI-formatted AWS credentials file. Providing the credentials as individual keys
(`AWS_ACCESS_KEY_ID` / `AWS_SECRET_ACCESS_KEY`) is **not** recognized by the plugin and
causes the `BackupStorageLocation` to fail validation.

### Incorrect Secret format (causes failure)

```yaml
stringData:
  AWS_ACCESS_KEY_ID: "velero"
  AWS_SECRET_ACCESS_KEY: "<secret>"
```

### Correct Secret format

```yaml
stringData:
  cloud: |
    [default]
    aws_access_key_id=velero
    aws_secret_access_key=<secret>
```

---

## Resolution

### 1. Update the credentials Secret

Edit `kubernetes/velero/secret.yaml` so it uses the `cloud` key:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: velero-s3-credentials
  namespace: velero
type: Opaque
stringData:
  cloud: |
    [default]
    aws_access_key_id=<ACCESS_KEY>
    aws_secret_access_key=<SECRET_KEY>
```

Apply it:

```bash
kubectl apply -f kubernetes/velero/secret.yaml
```

### 2. Restart the Velero deployment

```bash
kubectl rollout restart deployment/velero -n velero
kubectl rollout status deployment/velero -n velero
```

### 3. Verify the BackupStorageLocation is Available

```bash
velero backup-location get
```

Expected output:

```
NAME      PROVIDER   BUCKET/PREFIX   PHASE       LAST VALIDATED   ACCESS MODE   DEFAULT
default   aws        velero          Available   ...              ReadWrite     true
```

### 4. Delete the failed backup and recreate it

```bash
velero backup delete my-backup --confirm
velero backup create my-backup
```

### 5. Confirm the new backup completes

```bash
velero backup get my-backup
```

Expected output:

```
NAME        STATUS      ERRORS   WARNINGS   CREATED   EXPIRES   STORAGE LOCATION   SELECTOR
my-backup   Completed   0        0          ...       29d       default            <none>
```

---

## Prevention

Ensure any Velero credentials Secret deployed to the cluster (via Helm values,
GitOps manifests, or Terraform) uses the `cloud` key with the AWS INI format.
When installing via Helm, the equivalent value is:

```yaml
credentials:
  secretContents:
    cloud: |
      [default]
      aws_access_key_id=<ACCESS_KEY>
      aws_secret_access_key=<SECRET_KEY>
```

---

## References

- [Velero — AWS Plugin credentials configuration](https://github.com/vmware-tanzu/velero-plugin-for-aws#setup)
- [Velero documentation](https://velero.io/docs/)
- [BackupStorageLocation API reference](https://velero.io/docs/main/api-types/backupstoragelocation/)
