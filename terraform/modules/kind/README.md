## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_kind"></a> [kind](#requirement\_kind) | 0.8.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kind"></a> [kind](#provider\_kind) | 0.8.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [kind_cluster.main](https://registry.terraform.io/providers/tehcyx/kind/0.8.0/docs/resources/cluster) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the cluster | `string` | n/a | yes |
| <a name="input_cluster_type"></a> [cluster\_type](#input\_cluster\_type) | Type of the cluster, used in naming | `string` | `"hub"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Name of the environment | `string` | `"dev"` | no |
| <a name="input_extra_mounts"></a> [extra\_mounts](#input\_extra\_mounts) | List of extra mounts to add to the control-plane node | <pre>list(object({<br/>    host_path      = string<br/>    container_path = string<br/>  }))</pre> | `[]` | no |
| <a name="input_kubeconfig_path"></a> [kubeconfig\_path](#input\_kubeconfig\_path) | Path to save the kubeconfig | `string` | n/a | yes |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | Version of the Kind node image | `string` | `"1.31.2"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_client_certificate"></a> [client\_certificate](#output\_client\_certificate) | The client certificate for the KIND cluster |
| <a name="output_client_key"></a> [client\_key](#output\_client\_key) | The client key for the KIND cluster |
| <a name="output_cluster_ca_certificate"></a> [cluster\_ca\_certificate](#output\_cluster\_ca\_certificate) | The cluster CA certificate for the KIND cluster |
| <a name="output_cluster_endpoint"></a> [cluster\_endpoint](#output\_cluster\_endpoint) | The endpoint of the KIND cluster |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | The name of the KIND cluster |
| <a name="output_kubeconfig_path"></a> [kubeconfig\_path](#output\_kubeconfig\_path) | The path to the kubeconfig file for this cluster |
