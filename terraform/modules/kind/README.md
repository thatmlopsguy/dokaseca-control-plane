<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_kind"></a> [kind](#requirement\_kind) | >= 0.10.0, < 1.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kind"></a> [kind](#provider\_kind) | >= 0.10.0, < 1.0.0 |
| <a name="provider_local"></a> [local](#provider\_local) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [kind_cluster.main](https://registry.terraform.io/providers/tehcyx/kind/latest/docs/resources/cluster) | resource |
| [local_file.kubeconfig](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.kubeconfig_dir](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Defines the name of the cluster | `string` | `"local-cluster"` | no |
| <a name="input_cluster_type"></a> [cluster\_type](#input\_cluster\_type) | Type of the cluster, used in naming | `string` | `"hub"` | no |
| <a name="input_disable_default_cni"></a> [disable\_default\_cni](#input\_disable\_default\_cni) | If true, disables the default CNI (Container Network Interface) plugin in the kind cluster | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Name of the environment | `string` | `"dev"` | no |
| <a name="input_extra_mounts"></a> [extra\_mounts](#input\_extra\_mounts) | List of extra mounts to add to the control-plane node | <pre>list(object({<br/>    host_path      = string<br/>    container_path = string<br/>  }))</pre> | `[]` | no |
| <a name="input_kubeconfig_path"></a> [kubeconfig\_path](#input\_kubeconfig\_path) | Path to save the kubeconfig | `string` | n/a | yes |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | Defines the kubernetes version to be used | `string` | `"1.35.1"` | no |
| <a name="input_port_configuration"></a> [port\_configuration](#input\_port\_configuration) | Defines the port mappings for the cluster nodes | <pre>map(object({<br/>    app_protocol = string<br/>    node_port    = number<br/>    host_port    = number<br/>    target_port  = number<br/>    protocol     = string<br/>  }))</pre> | <pre>{<br/>  "http": {<br/>    "app_protocol": "http",<br/>    "host_port": 80,<br/>    "node_port": 30000,<br/>    "protocol": "TCP",<br/>    "target_port": 80<br/>  },<br/>  "https": {<br/>    "app_protocol": "https",<br/>    "host_port": 443,<br/>    "node_port": 30001,<br/>    "protocol": "TCP",<br/>    "target_port": 443<br/>  }<br/>}</pre> | no |
| <a name="input_region"></a> [region](#input\_region) | region of the kubernetes cluster | `string` | `"north-america"` | no |
| <a name="input_worker_nodes"></a> [worker\_nodes](#input\_worker\_nodes) | Defines the number of worker nodes to be created | `number` | `1` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_client_certificate"></a> [client\_certificate](#output\_client\_certificate) | The client certificate for the KIND cluster |
| <a name="output_client_key"></a> [client\_key](#output\_client\_key) | The client key for the KIND cluster |
| <a name="output_cluster_ca_certificate"></a> [cluster\_ca\_certificate](#output\_cluster\_ca\_certificate) | The cluster CA certificate for the KIND cluster |
| <a name="output_cluster_endpoint"></a> [cluster\_endpoint](#output\_cluster\_endpoint) | The endpoint of the KIND cluster |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | The name of the KIND cluster |
| <a name="output_kubeconfig_path"></a> [kubeconfig\_path](#output\_kubeconfig\_path) | The path to the kubeconfig file for this cluster |
<!-- END_TF_DOCS -->