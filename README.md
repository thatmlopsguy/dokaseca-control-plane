# k8s-homelab

My kubernetes homelab to test some applications.

## Prerequisite

* [Docker](https://www.docker.com/)
* [Kind](https://kind.sigs.k8s.io/docs/user/quick-start/)
* [Helm](https://helm.sh/docs/intro/install/)
* [Kubectl](https://kubernetes.io/docs/tasks/tools/)
* [kustomize](https://kustomize.io/)
* [k9s](https://k9scli.io/) (optional, if you'd like to inspect your cluster visually)

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
sudo sysctl fs.inotify.max_user_watches=524288
sudo sysctl fs.inotify.max_user_instances=512
```

Source: [Pod errors due to “too many open files”](https://kind.sigs.k8s.io/docs/user/known-issues/#pod-errors-due-to-too-many-open-files)

## Installation

The following command with create a kind cluster.

```sh
make terraform-apply
```

If you enable in `terraform.tfvars` the gitops bridge by setting `enable_gitops_bridge = true`, then argocd will be also
installed and all the enabled addons.

You can inspect the deployed clusters by typing:

```sh
$ kind get clusters
main
