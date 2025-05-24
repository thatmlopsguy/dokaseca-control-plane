<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kind"></a> [kind](#provider\_kind) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [kind_cluster.main](https://registry.terraform.io/providers/hashicorp/kind/latest/docs/resources/cluster) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the Kind cluster | `string` | `"main"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Name of the environment | `string` | `"dev"` | no |
| <a name="input_kubeconfig_path"></a> [kubeconfig\_path](#input\_kubeconfig\_path) | Path to save the kubeconfig | `string` | n/a | yes |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | Version of the Kind node image | `string` | `"v1.31.2"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->