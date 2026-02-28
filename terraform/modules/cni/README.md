<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_calico"></a> [calico](#module\_calico) | ./calico | n/a |
| <a name="module_cilium"></a> [cilium](#module\_cilium) | ./cilium | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cni_version"></a> [cni\_version](#input\_cni\_version) | The version of the CNI plugin to deploy | `string` | n/a | yes |
| <a name="input_kubeconfig_path"></a> [kubeconfig\_path](#input\_kubeconfig\_path) | Path to the kubeconfig file | `string` | `""` | no |
| <a name="input_kubernetes_cni"></a> [kubernetes\_cni](#input\_kubernetes\_cni) | Kubernetes CNI plugin to use | `string` | `"default"` | no |
| <a name="input_wait_for_ready"></a> [wait\_for\_ready](#input\_wait\_for\_ready) | Whether to wait for CNI to be fully ready after deployment | `bool` | `true` | no |
| <a name="input_wait_timeout"></a> [wait\_timeout](#input\_wait\_timeout) | Timeout for waiting for resources to be ready | `string` | `"300s"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_calico_custom_resources_url"></a> [calico\_custom\_resources\_url](#output\_calico\_custom\_resources\_url) | The URL of the Calico custom resources manifest (if Calico is the selected CNI) |
| <a name="output_calico_tigera_operator_url"></a> [calico\_tigera\_operator\_url](#output\_calico\_tigera\_operator\_url) | The URL of the Tigera Operator manifest (if Calico is the selected CNI) |
| <a name="output_calico_version"></a> [calico\_version](#output\_calico\_version) | The version of Calico deployed (if Calico is the selected CNI) |
| <a name="output_cni_enabled"></a> [cni\_enabled](#output\_cni\_enabled) | Whether a CNI plugin was deployed (false if 'default') |
| <a name="output_cni_type"></a> [cni\_type](#output\_cni\_type) | The CNI plugin type that was deployed |
<!-- END_TF_DOCS -->