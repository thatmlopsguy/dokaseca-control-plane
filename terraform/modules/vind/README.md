<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_local"></a> [local](#requirement\_local) | >= 2.0.0, < 3.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_local"></a> [local](#provider\_local) | >= 2.0.0, < 3.0.0 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [local_file.configuration](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [terraform_data.kubeconfig](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |
| [terraform_data.vind_cluster_apply](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |
| [terraform_data.vind_cluster_destroy](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |
| [local_file.configuration](https://registry.terraform.io/providers/hashicorp/local/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Defines the name of the cluster | `string` | `"local-cluster"` | no |
| <a name="input_enable_default_cni"></a> [enable\_default\_cni](#input\_enable\_default\_cni) | Enable the default CNI (Flannel) for the cluster. Consider disabling this, if you want to use a different CNI plugin | `bool` | `true` | no |
| <a name="input_enable_private_nodes"></a> [enable\_private\_nodes](#input\_enable\_private\_nodes) | Enable private nodes for the cluster. Requires VCluster Platform to be enabled | `bool` | `false` | no |
| <a name="input_enable_telemetry"></a> [enable\_telemetry](#input\_enable\_telemetry) | Enable telemetry for the cluster | `bool` | `false` | no |
| <a name="input_enable_vcluster_platform"></a> [enable\_vcluster\_platform](#input\_enable\_vcluster\_platform) | Enable VCluster Platform for the cluster. Required for private nodes | `bool` | `false` | no |
| <a name="input_kubeconfig_save_path"></a> [kubeconfig\_save\_path](#input\_kubeconfig\_save\_path) | Defines the path to save the kubeconfig file | `string` | `"kubeconfig"` | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | Defines the kubernetes version to be used | `string` | `"1.35.1"` | no |
| <a name="input_worker_nodes"></a> [worker\_nodes](#input\_worker\_nodes) | Defines the number of worker nodes to be created | `number` | `1` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | The name of the VIND cluster |
| <a name="output_kubeconfig_path"></a> [kubeconfig\_path](#output\_kubeconfig\_path) | The path to the kubeconfig file for this cluster |
<!-- END_TF_DOCS -->