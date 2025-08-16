# Multi-Cluster centralized hub-spoke topology

This example deploys ArgoCD on the Hub cluster. The spoke clusters are registered as remote clusters in the Hub Cluster's ArgoCD.
The Hub Cluster deploys addons and workloads to the spoke clusters.

## Deployment

The Hub cluster is deployed first, followed by the Spoke clusters.

```bash
cd hub
terraform init
terraform apply -auto-approve
kind get clusters
```

The Spoke clusters are registered with the Hub's ArgoCD instance.

```bash
cd spoke
./deploy.sh dev
./deploy.sh stg
./deploy.sh prod
```

Check the ArgoCD UI to verify the Spoke clusters are registered or verify the ArgoCD secrets:

```bash
# change the context to the hub cluster
$ kubectl get secrets -n argocd | grep spoke
spoke-dev                         Opaque               3      6m47s
spoke-stg                         Opaque               3      110s
spoke-prod                        Opaque               3      5m32s
```
