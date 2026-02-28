<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.7 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.10.1 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.37 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | >= 2.10.1 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >= 2.37 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.flux_instance](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.flux_operator](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_namespace.flux_system](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_secret.git_auth](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_size"></a> [cluster\_size](#input\_cluster\_size) | Cluster size, e.g. small, medium, large | `string` | `"small"` | no |
| <a name="input_cluster_type"></a> [cluster\_type](#input\_cluster\_type) | Cluster type, e.g. kubernetes, openshift, azure, aws, gcp | `string` | `"kubernetes"` | no |
| <a name="input_flux_registry"></a> [flux\_registry](#input\_flux\_registry) | Flux distribution registry | `string` | `"ghcr.io/fluxcd"` | no |
| <a name="input_flux_version"></a> [flux\_version](#input\_flux\_version) | Flux version semver range | `string` | `"2.x"` | no |
| <a name="input_git_path"></a> [git\_path](#input\_git\_path) | Path to the cluster manifests in the Git repository | `string` | `"clusters/production"` | no |
| <a name="input_git_ref"></a> [git\_ref](#input\_git\_ref) | Git branch or tag in the format refs/heads/main or refs/tags/v1.0.0 | `string` | `"refs/heads/main"` | no |
| <a name="input_git_token"></a> [git\_token](#input\_git\_token) | Git PAT | `string` | `""` | no |
| <a name="input_git_url"></a> [git\_url](#input\_git\_url) | Git repository URL | `string` | `"https://github.com/fluxcd/flux2-kustomize-helm-example.git"` | no |
| <a name="input_github_app_id"></a> [github\_app\_id](#input\_github\_app\_id) | GitHub App ID | `string` | `""` | no |
| <a name="input_github_app_installation_owner"></a> [github\_app\_installation\_owner](#input\_github\_app\_installation\_owner) | GitHub App Installation Owner | `string` | `""` | no |
| <a name="input_github_app_pem"></a> [github\_app\_pem](#input\_github\_app\_pem) | The contents of the GitHub App private key PEM file | `string` | `""` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Kubernetes namespace to deploy Flux2 in | `string` | `"flux-system"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_release_name"></a> [release\_name](#output\_release\_name) | Name of the Helm release |
<!-- END_TF_DOCS -->