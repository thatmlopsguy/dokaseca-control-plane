<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [kubernetes_namespace.external_secrets](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_secret.vault_token](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_manage_namespace"></a> [manage\_namespace](#input\_manage\_namespace) | Whether to manage the namespace creation in this module. | `bool` | `false` | no |
| <a name="input_vault_token"></a> [vault\_token](#input\_vault\_token) | A Vault token to create in the external-secrets namespace for the External Secrets operator to use. If empty, no secret will be created. | `string` | n/a | yes |
| <a name="input_vault_token_secret_name"></a> [vault\_token\_secret\_name](#input\_vault\_token\_secret\_name) | Name of the Kubernetes secret to create for the Vault token. | `string` | `"vault-token"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->