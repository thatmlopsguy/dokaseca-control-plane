# GitOps Bridge Module

This Terraform module sets up a GitOps bridge to facilitate continuous deployment and management of infrastructure and applications using GitOps principles.
It integrates with popular Git repositories and CI/CD tools to automate the deployment process.

Fork of `https://github.com/gitops-bridge-dev/terraform-helm-gitops-bridge`

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.10.1 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.22.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | >= 2.10.1 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >= 2.22.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.argocd](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.bootstrap](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_secret_v1.cluster](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret_v1) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_apps"></a> [apps](#input\_apps) | argocd app of apps to deploy | `any` | `{}` | no |
| <a name="input_argocd"></a> [argocd](#input\_argocd) | argocd helm options | `any` | `{}` | no |
| <a name="input_cluster"></a> [cluster](#input\_cluster) | argocd cluster secret | `any` | `null` | no |
| <a name="input_create"></a> [create](#input\_create) | Create terraform resources | `bool` | `true` | no |
| <a name="input_install"></a> [install](#input\_install) | Deploy argocd helm | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_apps"></a> [apps](#output\_apps) | ArgoCD apps |
| <a name="output_argocd"></a> [argocd](#output\_argocd) | Argocd helm release |
| <a name="output_cluster"></a> [cluster](#output\_cluster) | ArgoCD cluster |
<!-- END_TF_DOCS -->