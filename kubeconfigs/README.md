# Kubeconfigs

Place to store the kubeconfigs for all clusters created via terraform.

Example:

```sh
export KUBECONFIG=./kubeconfigs/hub-dev
export KUBECONFIG=./kubeconfigs/spoke-dev
export KUBECONFIG=./kubeconfigs/spoke-stg
export KUBECONFIG=./kubeconfigs/spoke-prod
```

Add multiple kubeconfigs

```sh
export KUBECONFIG="./kubeconfigs/hub-dev:./kubeconfigs/spoke-dev:./kubeconfigs/spoke-stg:./kubeconfigs/spoke-prod"
```

Use [kubectx](https://github.com/ahmetb/kubectx) to switch between kubernetes contexts
