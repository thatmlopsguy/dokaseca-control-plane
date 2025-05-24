<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | 1.19.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | n/a |
| <a name="provider_kubectl"></a> [kubectl](#provider\_kubectl) | 1.19.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.flux2](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubectl_manifest.git_repository](https://registry.terraform.io/providers/gavinbunney/kubectl/1.19.0/docs/resources/manifest) | resource |
| [kubectl_manifest.kustomization](https://registry.terraform.io/providers/gavinbunney/kubectl/1.19.0/docs/resources/manifest) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_chart_version"></a> [chart\_version](#input\_chart\_version) | fluxcd helm chart version | `string` | `"2.15.0"` | no |
| <a name="input_kustomization_path"></a> [kustomization\_path](#input\_kustomization\_path) | Path within the repository to look for kustomization files | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Kubernetes namespace to deploy Flux2 in | `string` | `"flux-system"` | no |
| <a name="input_repository_branch"></a> [repository\_branch](#input\_repository\_branch) | Branch to track in the Git repository | `string` | `"main"` | no |
| <a name="input_repository_url"></a> [repository\_url](#input\_repository\_url) | URL of the Git repository containing Kubernetes manifests | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_release_name"></a> [release\_name](#output\_release\_name) | Name of the Helm release |
<!-- END_TF_DOCS -->