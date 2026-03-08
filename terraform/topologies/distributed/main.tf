module "kind_cluster" {
  source = "git::https://github.com/thatmlopsguy/dokaseca-control-plane.git//terraform/modules/kind?ref=main"

  count = var.kubernetes_distro == "kind" ? 1 : 0

  # Pass required variables here
  environment = var.environment
  region      = var.region

  cluster_name       = local.kubernetes_name
  cluster_type       = var.cluster_type
  kubernetes_version = var.kubernetes_version
  kubeconfig_path    = local.kubeconfig_path

  # Use Cilium as CNI
  disable_default_cni = var.kubernetes_cni != "default"
}

module "vind_cluster" {
  source = "git::https://github.com/thatmlopsguy/dokaseca-control-plane.git//terraform/modules/vind?ref=main"

  count = var.kubernetes_distro == "vind" ? 1 : 0

  cluster_name         = local.kubernetes_name
  kubernetes_version   = var.kubernetes_version
  kubeconfig_save_path = local.kubeconfig_path

  enable_default_cni       = var.kubernetes_cni == "default"
  enable_telemetry         = false
  enable_vcluster_platform = false
  enable_private_nodes     = false
}

module "gitops_bridge" {
  source = "git::https://github.com/thatmlopsguy/dokaseca-control-plane.git//terraform/modules/gitops-bridge?ref=main"

  count = var.gitops_controller == "argocd" ? 1 : 0

  # Pass required variables here
  environment = var.environment
  region      = var.region

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
