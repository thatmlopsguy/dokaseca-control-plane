# Kubeconfigs

Place to store the kubeconfigs for all clusters created via terraform.

Example:

```sh
export KUBECONFIG=./kubeconfigs/control-plane-dev
export KUBECONFIG=./kubeconfigs/team-a-dev
```

Add multiple kubeconfigs

```sh
export KUBECONFIG="./kubeconfigs/control-plane-dev:./kubeconfigs/team-a-dev"
```

Use [kubectx](https://github.com/ahmetb/kubectx) to swtich between kuberntes contexts
