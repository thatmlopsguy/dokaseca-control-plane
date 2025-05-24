# Doka Seca Terraform

[![GitHub](https://img.shields.io/github/stars/thatmlopsguy/dokaseca-terraform?style=flat&label=GitHub%20%E2%AD%90)](https://github.com/thatmlopsguy/dokaseca-terraform)
[![GitHub last commit](https://img.shields.io/github/last-commit/thatmlopsguy/dokaseca-terraform.svg)](https://github.com/thatmlopsguy/dokaseca-terraform/commits/main)
[![GitHub issues](https://img.shields.io/github/issues/thatmlopsguy/dokaseca-terraform.svg)](https://github.com/thatmlopsguy/dokaseca-terraform/issues)
[![GitHub PRs](https://img.shields.io/github/issues-pr/thatmlopsguy/dokaseca-terraform)](https://github.com/thatmlopsguy/dokaseca-terraform/pulls)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://github.com/thatmlopsguy/dokaseca-terraform/blob/dev/LICENSE)
[![Website](https://img.shields.io/website-up-down-green-red/http/shields.io.svg)](https://thatmlopsguy.github.io/dokaseca-terraform/)

## Introduction

Welcome to my homelab Kubernetes cluster repository! This project serves as both a personal learning journey and a
resource for others interested in setting up their own Kubernetes Homelabs.

## Prerequisite

* [Docker](https://www.docker.com/)
* [Terraform](https://www.terraform.io/)
* [Kind](https://kind.sigs.k8s.io/docs/user/quick-start/), [k0s](https://docs.k0sproject.io/stable/) and/or [k3d](https://k3d.io/stable/)
* [jq](https://jqlang.github.io/jq/)
* [Helm](https://helm.sh/docs/intro/install/)
* [Kubectl](https://kubernetes.io/docs/tasks/tools/)
* [kustomize](https://kustomize.io/)
* [k9s](https://k9scli.io/) or [freelens](https://github.com/freelensapp/freelens) (optional, if you'd like to inspect your cluster visually)

## Optional tools

* [argocd](https://argo-cd.readthedocs.io/en/stable/cli_installation/)
* [vcluster](https://www.vcluster.com/docs/platform/install/quick-start-guide)
* [falcoctl](https://github.com/falcosecurity/falcoctl)
* [karmor](https://kubearmor.io/)
* [clusteradm](https://github.com/open-cluster-management-io/clusteradm)
* [cosign](https://github.com/sigstore/cosign)
* [velero](https://github.com/vmware-tanzu/velero)

```sh
$ kubectl version
Client Version: v1.31.0
Kustomize Version: v5.4.2
Server Version: v1.30.0

$ kind version
kind v0.27.0 go1.23.6 linux/amd64

$ k3d --version
k3d version v5.8.3
k3s version v1.31.5-k3s1 (default)

$ k0s version
v1.32.4+k0s.0

$ helm version
version.BuildInfo{Version:"v3.16.1", GitCommit:"v3.16.1", GitTreeState:"", GoVersion:"go1.22.7"}
```

To increase these limits temporarily run the following commands on the host:

```sh
sudo sysctl fs.inotify.max_user_watches=1048576
sudo sysctl fs.inotify.max_user_instances=8192
```

Source: [Pod errors due to “too many open files”](https://kind.sigs.k8s.io/docs/user/known-issues/#pod-errors-due-to-too-many-open-files)

## Installation

The following command with create a kind cluster.

```sh
./scripts/terraform.sh control-plane dev apply
```

You can inspect the deployed clusters by typing:

```sh
$ kind get clusters
control-plane-dev
```

If you enable in `terraform.tfvars` the gitops bridge by setting `enable_gitops_bridge = true`, then argocd will be also
installed and all the enabled addons. You can see that terraform will add GitOps Bridge Metadata to the ArgoCD secret.
The annotations contain metadata for the addons' Helm charts and ArgoCD ApplicationSets.

```sh
kubectl get secret -n argocd -l argocd.argoproj.io/secret-type=cluster -o json | jq '.items[0].metadata.annotations'
```

The output looks like the following:

```json
{
  "addons_extras_repo_basepath": "stable",
  "addons_extras_repo_revision": "main",
  "addons_extras_repo_url": "https://github.com/thatmlopsguy/helm-charts",
  "addons_repo_basepath": "argocd",
  "addons_repo_path": "appsets",
  "addons_repo_revision": "main",
  "addons_repo_url": "https://github.com/thatmlopsguy/dokaseca-addons",
  "cluster_name": "control-plane-dev",
  "cluster_repo_basepath": "gitops/argocd",
  "cluster_repo_path": "clusters",
  "cluster_repo_revision": "dev",
  "cluster_repo_url": "https://github.com/thatmlopsguy/k8s-homelab",
  "environment": "dev",
  "workload_repo_basepath": "gitops/argocd",
  "workload_repo_path": "workloads",
  "workload_repo_revision": "dev",
  "workload_repo_url": "https://github.com/thatmlopsguy/k8s-homelab"
}
```

The labels offer a straightforward way to enable or disable an addon in ArgoCD for the cluster.

```sh
kubectl get secret -n argocd -l argocd.argoproj.io/secret-type=cluster -o json | jq '.items[0].metadata.labels'
```

The output looks like the following:

```json
{
  "argocd.argoproj.io/secret-type": "cluster",
  "cloud_provider": "local",
  "cluster_name": "control-plane-dev",
  "enable_alloy": "false",
  "enable_argo_cd": "true",
  "enable_argo_cd_image_updater": "false",
  "enable_argo_events": "false",
  "enable_argo_rollouts": "false",
  "enable_argo_workflows": "false",
  "enable_trivy": "false",
  "enable_vault": "false",
  "enable_vcluster": "false",
  "enable_vector": "false",
  "enable_victoria_metrics_k8s_stack": "true",
  "enable_zipkin": "false",
  "environment": "dev",
  "k8s_cluster_name": "control-plane-dev",
  "k8s_domain_name": "k8s-home.lab",
  "kubernetes_version": "1.31.2"
}
```

## Destroy kind Cluster

To tear down all the resources and the kind cluster, run the following command:

```sh
./scripts/terraform.sh control-plane dev destroy
```

## :handshake: Contributing

Anyone is welcome to collaborate to this project. Check out our [contributing guidelines](CONTRIBUTING.md).

## :bookmark: License

Doca Seca is licensed under [Apache License, Version 2.0](LICENSE)
