# Calico CNI Terraform Module

This module installs [Calico CNI](https://www.tigera.io/project-calico/) using the Tigera Operator.

## Usage

```hcl
module "calico" {
  source = "./terraform/modules/cni/calico"

  calico_version  = "v3.26.1"
  kubeconfig_path = "~/.kube/config"
  wait_for_ready  = true
  wait_timeout    = "300s"
}
```

## What it does

This module applies the following manifests:

1. **Tigera Operator** - The operator that manages Calico components
2. **Custom Resources** - The Installation CRD that configures Calico

Equivalent to running:

```bash
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.26.1/manifests/tigera-operator.yaml
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.26.1/manifests/custom-resources.yaml
```

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [terraform_data.calico_custom_resources_deploy](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |
| [terraform_data.calico_custom_resources_destroy](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |
| [terraform_data.tigera_operator_deploy](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |
| [terraform_data.tigera_operator_destroy](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |
| [terraform_data.wait_for_calico](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |
| [terraform_data.wait_for_operator](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_calico_version"></a> [calico\_version](#input\_calico\_version) | The version of Calico to deploy | `string` | `"v3.26.1"` | no |
| <a name="input_kubeconfig_path"></a> [kubeconfig\_path](#input\_kubeconfig\_path) | Path to the kubeconfig file | `string` | n/a | yes |
| <a name="input_wait_for_ready"></a> [wait\_for\_ready](#input\_wait\_for\_ready) | Whether to wait for Calico to be fully ready after deployment | `bool` | `true` | no |
| <a name="input_wait_timeout"></a> [wait\_timeout](#input\_wait\_timeout) | Timeout for waiting for resources to be ready | `string` | `"300s"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_calico_version"></a> [calico\_version](#output\_calico\_version) | The version of Calico deployed |
| <a name="output_custom_resources_url"></a> [custom\_resources\_url](#output\_custom\_resources\_url) | The URL of the Calico custom resources manifest |
| <a name="output_tigera_operator_url"></a> [tigera\_operator\_url](#output\_tigera\_operator\_url) | The URL of the Tigera Operator manifest |
<!-- END_TF_DOCS -->
