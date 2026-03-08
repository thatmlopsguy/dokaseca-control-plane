module "kind_cluster" {
  source = "./../../modules/kind"

  cluster_name       = local.kubernetes_name
  cluster_type       = var.cluster_type
  environment        = var.environment
  kubernetes_version = var.kubernetes_version
  kubeconfig_path    = local.kubeconfig_path
}

module "gitops_bridge" {
  source = "./../../modules/gitops-bridge"

  count = var.gitops_controller == "argocd" ? 1 : 0

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
