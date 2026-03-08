# Vault External Secrets Tutorial

This tutorial shows how to read a KV secret from HashiCorp Vault (KV v2) using External Secrets and sync it into Kubernetes as a `Secret`.

Files used in this example:

- [examples/external-secrets/ClusterSecretStore.yaml](examples/external-secrets/ClusterSecretStore.yaml)
- [examples/external-secrets/external-secret-dev.yaml](examples/external-secrets/external-secret-dev.yaml)

## Prerequisites

- A running Kubernetes cluster and `kubectl` configured
- Vault server reachable from the cluster (this example uses `http://vault:8200`)
- Vault CLI (`vault`) available locally for examples in this document
- A Vault token with permission to read the KV secret

## Overview

1. Ensure Vault's KV engine is mounted as KV v2 at the mount path `kv`.
2. Write a secret into Vault at `kv/data/dev` (KV v2 API path).
3. Create a Kubernetes Secret that contains a Vault token (used by External Secrets controller).
4. Deploy the `ClusterSecretStore` pointing to Vault and set `version: v2`.
5. Apply the `ExternalSecret` which references the store and the Vault key/property.
6. Verify the Kubernetes `Secret` is created.

## Step-by-step

1) Confirm KV v2 mount and write secret (example using Vault CLI):

```sh
# vault login <VAULT_TOKEN>
vault login root

# confirm mount
vault secrets list -detailed

# write secret into KV v2 at mount `kv` under key `dev`
vault kv put kv/dev apiKey=1234
```

2) Create a Kubernetes Secret with the Vault token (example uses a token value `s.TOKEN`):

```sh
kubectl create namespace external-secrets || true
kubectl apply -f auth.yaml
```

1) Ensure `ClusterSecretStore` is configured to use KV v2. The example file is at [examples/external-secrets/ClusterSecretStore.yaml](examples/external-secrets/ClusterSecretStore.yaml).

Key points in the store configuration:

- `spec.provider.vault.path: kv`
- `spec.provider.vault.version: v2`
- `spec.provider.vault.server: http://vault:8200`
- `spec.provider.vault.auth.tokenSecretRef` should point to the `vault-token` secret in `external-secrets` namespace

Apply the store (if not already applied):

```sh
kubectl apply -f examples/external-secrets/ClusterSecretStore.yaml
```

4) Apply the `ExternalSecret` that defines the data mapping (this repo includes [examples/external-secrets/external-secret-dev.yaml](examples/external-secrets/external-secret-dev.yaml)):

```sh
kubectl apply -f examples/external-secrets/external-secret-dev.yaml
```

5) Verify sync and the created Kubernetes Secret:

```sh
kubectl describe externalsecret dev-api-key -n external-secrets
kubectl get secret dev-api-credentials -n external-secrets -o yaml
```

If you see the ExternalSecret condition `Ready: True` and the `dev-api-credentials` `Secret` exists, sync succeeded.

## Troubleshooting

- Error `Secret does not exist` in ExternalSecret events/logs: typically means the controller attempted to read a non-existent path with the wrong KV API. If your Vault mount is KV v2, make sure `spec.provider.vault.version: v2` in the `ClusterSecretStore`. If the store uses `v1` while Vault is v2, the controller will not find the secret (the UI may show paths like `kv/kv/dev`).

- To view controller logs:

```sh
kubectl logs -n external-secrets deployment/external-secrets --tail=200
```

## Example quick-check commands

```sh
# show the Kubernetes Secret
kubectl get secret dev-api-credentials -n external-secrets -o yaml

# describe ExternalSecret
kubectl describe externalsecret dev-api-key -n external-secrets

# check Vault path using curl from a pod (demonstration)
kubectl run -n external-secrets --rm -it --restart=Never vault-curl --image=curlimages/curl -- /bin/sh -c "curl -sS -H 'X-Vault-Token: s.TOKEN' http://vault:8200/v1/kv/data/dev"
```

## Notes

- This tutorial assumes a dev/test environment where plain tokens are acceptable. For production, use proper Vault auth methods (Kubernetes auth, AppRole, etc.) and RBAC.
- The example manifests in this folder are ready to use; adjust the Vault server URL and token handling to match your environment.
