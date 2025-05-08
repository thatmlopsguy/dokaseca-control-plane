<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_local"></a> [local](#provider\_local) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [local_file.cluster_config](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [null_resource.install_k3d](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.k3d_cluster](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_agents"></a> [agents](#input\_agents) | Number of agent nodes | `number` | `2` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the k3d cluster | `string` | n/a | yes |
| <a name="input_disabled_components"></a> [disabled\_components](#input\_disabled\_components) | Components to disable in k3s | `list(string)` | <pre>[<br>  "traefik",<br>  "metrics-server"<br>]</pre> | no |
| <a name="input_k3d_version"></a> [k3d\_version](#input\_k3d\_version) | Version of k3d to install | `string` | `"latest"` | no |
| <a name="input_k3s_version"></a> [k3s\_version](#input\_k3s\_version) | Version of k3s to use | `string` | `"v1.31.5-k3s1"` | no |
| <a name="input_ports"></a> [ports](#input\_ports) | List of port mappings | <pre>list(object({<br>    host_port      = number<br>    container_port = number<br>    protocol       = string<br>  }))</pre> | `[]` | no |
| <a name="input_servers"></a> [servers](#input\_servers) | Number of server nodes | `number` | `1` | no |
| <a name="input_volume_mounts"></a> [volume\_mounts](#input\_volume\_mounts) | List of volume mounts | <pre>list(object({<br>    host_path      = string<br>    container_path = string<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | n/a |
<!-- END_TF_DOCS -->