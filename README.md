# k8s-homelab

[![GitHub](https://img.shields.io/github/stars/thatmlopsguy/k8s-homelab?style=flat&label=GitHub%20%E2%AD%90)](https://github.com/thatmlopsguy/k8s-homelab)
[![GitHub last commit](https://img.shields.io/github/last-commit/thatmlopsguy/k8s-homelab.svg)](https://github.com/thatmlopsguy/k8s-homelab/commits/main)
[![GitHub issues](https://img.shields.io/github/issues/thatmlopsguy/k8s-homelab.svg)](https://github.com/thatmlopsguy/k8s-homelab/issues)
[![GitHub PRs](https://img.shields.io/github/issues-pr/thatmlopsguy/k8s-homelab)](https://github.com/thatmlopsguy/k8s-homelab/pulls)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://github.com/thatmlopsguy/k8s-homelab/blob/dev/LICENSE)
[![Website](https://img.shields.io/website-up-down-green-red/http/shields.io.svg)](https://thatmlopsguy.github.io/k8s-homelab/)

## Introduction

Welcome to my homelab Kubernetes cluster repository! This project serves as both a personal learning journey and a
resource for others interested in setting up their own Kubernetes Homelabs.

## Prerequisite

* [Docker](https://www.docker.com/)
* [Terraform](https://www.terraform.io/)
* [Kind](https://kind.sigs.k8s.io/docs/user/quick-start/)
* [Helm](https://helm.sh/docs/intro/install/)
* [Kubectl](https://kubernetes.io/docs/tasks/tools/)
* [kustomize](https://kustomize.io/)
* [k9s](https://k9scli.io/) or [freelens](https://github.com/freelensapp/freelens) (optional, if you'd like to inspect your cluster visually)

```sh
$ kubectl version
Client Version: v1.30.1
Kustomize Version: v5.0.4-0.20230601165947-6ce0bf390ce3
Server Version: v1.30.0

$ kind version
kind v0.23.0 go1.22.5 linux/amd64

$ helm version
version.BuildInfo{Version:"v3.15.2", GitCommit:"v3.15.2", GitTreeState:"", GoVersion:"go1.22.5"}
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
make terraform-apply
```

You can inspect the deployed clusters by typing:

```sh
$ kind get clusters
main
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
  "addons_repo_basepath": "gitops",
  "addons_repo_path": "addons",
  "addons_repo_revision": "dev",
  "addons_repo_url": "https://github.com/thatmlopsguy/k8s-homelab",
  "cluster_name": "main",
  "environment": "prod"
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
  "cluster_name": "main",
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
  "environment": "prod",
  "k8s_cluster_name": "main",
  "kubernetes_version": "1.31.2"
}
```

## Destroy kind Cluster

To tear down all the resources and the kind cluster, run the following command:

```sh
make terraform-destroy
```

## :handshake: Contributing

Anyone is welcome to collaborate to this project. Check out our [contributing guidelines](CONTRIBUTING.md).

## :bookmark: License
 
Doca Seca is licensed under [Apache License, Version 2.0](LICENSE)