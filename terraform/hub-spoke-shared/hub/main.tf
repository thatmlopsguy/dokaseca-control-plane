module "kind_cluster" {
  source = "./../../modules/kind"

  cluster_name       = local.kubernetes_name
  cluster_type       = var.cluster_type
  environment        = var.environment
  kubernetes_version = var.kubernetes_version
  kubeconfig_path    = local.kubeconfig_path
}

module "gitops_bridge_bootstrap" {
  source = "git::https://github.com/gitops-bridge-dev/terraform-helm-gitops-bridge?ref=33c09eb68af1ee673040bde58c3188383c46c288"

  count = var.enable_gitops_bridge ? 1 : 0

  cluster = {
    cluster_name = local.kubernetes_name
    environment  = local.env
    metadata     = local.addons_metadata # metadata annotations
    addons       = local.addons          # metadata labels
  }

  argocd = {
    namespace     = "argocd"
    chart         = "argo-cd"
    chart_version = var.argocd_chart_version

    values = [local.argocd_helm_values]
  }

  apps = local.argocd_apps

  depends_on = [module.kind_cluster]
}
