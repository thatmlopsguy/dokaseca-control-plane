module "kind_cluster" {
  source = "./../modules/kind"

  count = var.kubernetes_distro == "kind" ? 1 : 0

  cluster_name       = local.kubernetes_name
  cluster_type       = var.cluster_type
  environment        = var.environment
  kubernetes_version = var.kubernetes_version
  kubeconfig_path    = local.kubeconfig_path

  # Use Cilium as CNI
  disable_default_cni = var.kubernetes_cni != "default"
}

module "vind_cluster" {
  source = "./../modules/vind"

  count = var.kubernetes_distro == "vind" ? 1 : 0

  cluster_name         = local.kubernetes_name
  kubernetes_version   = var.kubernetes_version
  kubeconfig_save_path = local.kubeconfig_path

  enable_default_cni       = var.kubernetes_cni == "default"
  enable_telemetry         = false
  enable_vcluster_platform = false
  enable_private_nodes     = false
}

module "gateway_api" {
  source = "./../modules/gateway_api"

  count = var.enable_gateway_api ? 1 : 0

  release_version = var.gateway_api_release_version
  kubeconfig_path = local.kubeconfig_path

  depends_on = [module.kind_cluster, module.vind_cluster]
}

module "cni" {
  source = "./../modules/cni"

  count = var.kubernetes_cni != "default" ? 1 : 0

  kubernetes_cni  = var.kubernetes_cni
  kubeconfig_path = local.kubeconfig_path
  cni_version     = var.kubernetes_cni_version

  depends_on = [module.kind_cluster, module.vind_cluster]
}

module "gitops_bridge" {
  source = "./../modules/gitops-bridge"

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

  depends_on = [module.kind_cluster, module.vind_cluster]
}

module "fluxcd_operator" {
  source = "./../modules/fluxcd"

  count = var.gitops_controller == "fluxcd" ? 1 : 0

  namespace                     = var.fluxcd_config.namespace
  flux_version                  = var.fluxcd_config.flux_version
  flux_registry                 = var.fluxcd_config.flux_registry
  cluster_type                  = var.fluxcd_config.cluster_type
  cluster_size                  = var.fluxcd_config.cluster_size
  git_token                     = var.fluxcd_config.git_token
  github_app_id                 = var.fluxcd_config.github_app_id
  github_app_installation_owner = var.fluxcd_config.github_app_installation_owner
  github_app_pem                = var.fluxcd_config.github_app_pem
  git_url                       = var.fluxcd_config.git_url
  git_path                      = var.fluxcd_config.git_path
  git_ref                       = var.fluxcd_config.git_ref

  depends_on = [module.kind_cluster, module.vind_cluster]
}
