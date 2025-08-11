<div align="center">

<img src="https://raw.githubusercontent.com/thatmlopsguy/dokaseca-control-plane/main/docs/assets/logos/banner.svg" alt="DoKa Seca - Kubernetes Platform Engineering Framework" width="600"/>

</div>

<div align="center">

*Just as ships are built in dry docks, platforms are crafted in DoKa Seca*

</div>

<div align="center">
  <a href="https://github.com/thatmlopsguy/dokaseca-control-plane"><img src="https://img.shields.io/github/stars/thatmlopsguy/dokaseca-control-plane?style=flat&label=GitHub%20%E2%AD%90" alt="GitHub"></a>
  <a href="https://github.com/thatmlopsguy/dokaseca-control-plane/commits/main"><img src="https://img.shields.io/github/last-commit/thatmlopsguy/dokaseca-control-plane.svg" alt="GitHub last commit"></a>
  <a href="https://github.com/thatmlopsguy/dokaseca-control-plane/graphs/commit-activity"><img src="https://img.shields.io/github/commit-activity/w/thatmlopsguy/dokaseca-control-plane" alt="Commit activity"></a>
  <a href="https://github.com/thatmlopsguy/dokaseca-control-plane/issues"><img src="https://img.shields.io/github/issues/thatmlopsguy/dokaseca-control-plane.svg" alt="GitHub issues"></a>
  <a href="https://github.com/thatmlopsguy/dokaseca-control-plane/pulls"><img src="https://img.shields.io/github/issues-pr/thatmlopsguy/dokaseca-control-plane" alt="GitHub PRs"></a>
  <a href="https://github.com/thatmlopsguy/dokaseca-control-plane/blob/dev/LICENSE"><img src="https://img.shields.io/badge/License-Apache%202.0-blue.svg" alt="License"></a>
  <a href="https://thatmlopsguy.github.io/dokaseca-control-plane/"><img src="https://img.shields.io/website-up-down-green-red/http/shields.io.svg" alt="Website"></a>
  <a href="https://github.com/thatmlopsguy/dokaseca-control-plane/actions/workflows/pre-commit.yml"><img src="https://github.com/thatmlopsguy/dokaseca-control-plane/workflows/Pre-commit%20Checks/badge.svg" alt="Pre-commit"></a>
  <a href="https://scorecard.dev/viewer/?uri=github.com/thatmlopsguy/dokaseca-control-plane"><img src="https://img.shields.io/ossf-scorecard/github.com/thatmlopsguy/dokaseca-control-plane?label=openssf+scorecard&style=flat" alt="Pre-commit"></a>
</div>

>⚠️ Note
>
> DoKa Seca is still in relatively early development. At this time, **do not use** Doka Seca for critical production systems.

## 👋 Introduction

Welcome to **DoKa Seca** - a comprehensive framework for bootstrapping cloud-native platforms using Kubernetes in Docker (Kind)! The name "DoKa Seca" is a playful Portuguese phrase where "DoKa" incorporates the "K" from Kubernetes (representing the containerized orchestration at the heart of this project), and "Seca" means "dry" - drawing inspiration from the concept of a **dry dock**.

Just as ships are built, repaired, and maintained in dry docks - controlled, isolated environments where all the necessary infrastructure and tooling are readily available - DoKa Seca provides a "dry dock" for Kubernetes platforms. It creates an isolated, controlled environment where entire cloud-native platforms can be rapidly assembled, configured, and tested before being deployed to production waters.

DoKa Seca provides an opinionated, production-ready framework that automates the entire platform bootstrap process using Kind clusters. Rather than just being a collection of configurations, it's a complete platform engineering solution that provisions infrastructure, installs essential tooling, configures GitOps workflows, and sets up observability - all with a single command, in your local "dry dock" environment.

This project serves as both a personal learning journey into modern DevOps practices and a comprehensive resource for platform engineers and developers interested in rapidly spinning up production-grade Kubernetes environments. Here you'll find real-world implementations of GitOps workflows, infrastructure as code, observability stacks, and cloud-native security practices - all designed to run efficiently in local development or homelab environments while following enterprise-grade patterns and best practices.

**Prerequisites**

* [`docker`](https://www.docker.com/)
* [`terraform`](https://www.terraform.io/) or [`opentofu`](https://opentofu.org/)
* [`Kind`](https://kind.sigs.k8s.io/docs/user/quick-start/), [`k0s`](https://docs.k0sproject.io/stable/) and/or [`k3d`](https://k3d.io/stable/)
* [`jq`](https://jqlang.github.io/jq/)
* [`helm`](https://helm.sh/docs/intro/install/)
* [`Kubectl`](https://kubernetes.io/docs/tasks/tools/)
* `base64`
* [`kustomize`](https://kustomize.io/)
* [`k9s`](https://k9scli.io/) or [`freelens`](https://github.com/freelensapp/freelens) (optional, if you'd like to inspect your cluster visually)

**Optional tools**

* [`argocd`](https://argo-cd.readthedocs.io/en/stable/cli_installation/)
* [`kargo`](https://docs.kargo.io/user-guide/installing-the-cli/)
* [`vcluster`](https://www.vcluster.com/docs/platform/install/quick-start-guide)
* [`falcoctl`](https://github.com/falcosecurity/falcoctl)
* [`karmor`](https://kubearmor.io/)
* [`clusteradm`](https://github.com/open-cluster-management-io/clusteradm)
* [`cosign`](https://github.com/sigstore/cosign)
* [`velero`](https://github.com/vmware-tanzu/velero)
* [`vault`](https://developer.hashicorp.com/vault/docs/install)
* [`minio client (mc)`](https://github.com/minio/mc)

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

## 🚀 Quick Start

```bash
# Deploy control plane cluster
./scripts/terraform.sh hub dev apply
```

You can inspect the deployed clusters by typing:

```sh
$ kind get clusters
hub-dev
spoke-dev
spoke-prod
spoke-stg
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
  "cluster_name": "hub-dev",
  "cluster_repo_basepath": "argocd",
  "cluster_repo_path": "clusters",
  "cluster_repo_revision": "dev",
  "cluster_repo_url": "https://github.com/thatmlopsguy/dokaseca-clusters",
  "environment": "dev",
  "workload_repo_basepath": "argocd",
  "workload_repo_path": "workloads",
  "workload_repo_revision": "dev",
  "workload_repo_url": "https://github.com/thatmlopsguy/dokaseca-workloads"
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
  "cluster_name": "hub-dev",
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
  "k8s_cluster_name": "hub-dev",
  "k8s_domain_name": "dokaseca.local",
  "kubernetes_version": "1.31.2"
}
```

## 💥 Destroy Infrastructure

To tear down all the resources and the kind cluster(s), run the following command:

```sh
make clean-infra
```

## ⚒️ FAQ

`ERROR: failed to create cluster: could not find a log line that matches "Reached target .*Multi-User System.*|detected cgroup v1"`

To increase these limits temporarily run the following commands on the host:

```sh
sudo sysctl fs.inotify.max_user_watches=1048576
sudo sysctl fs.inotify.max_user_instances=8192
```

Source: [Pod errors due to “too many open files”](https://kind.sigs.k8s.io/docs/user/known-issues/#pod-errors-due-to-too-many-open-files)

## 📚 Resources

User documentation can be found on our [user docs site](https://thatmlopsguy.github.io/dokaseca-control-plane/).

## 🤝 Contributing

All contributors are warmly welcome. If you want to become a new contributor, we are so happy! Just, before doing it,
read our [contributing guidelines](CONTRIBUTING.md).

## 🗺️ Roadmap

Want to know about the features to come? Check out the project [roadmap](ROADMAP.md) for more information.

## 🔖 License

DoKa Seca is licensed under [Apache License, Version 2.0](LICENSE)
