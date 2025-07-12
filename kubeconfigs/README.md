# Kubeconfigs

Place to store the kubeconfigs for all clusters created via terraform.

Example:

```sh
export KUBECONFIG=./kubeconfigs/control-plane-dev
export KUBECONFIG=./kubeconfigs/workloads-dev
export KUBECONFIG=./kubeconfigs/workloads-stg
export KUBECONFIG=./kubeconfigs/workloads-prod
```

Add multiple kubeconfigs

```sh
export KUBECONFIG="./kubeconfigs/control-plane-dev:./kubeconfigs/workloads-dev:./kubeconfigs/workloads-stg:./kubeconfigs/workloads-prod"
```

Use [kubectx](https://github.com/ahmetb/kubectx) to swtich between kuberntes contexts
