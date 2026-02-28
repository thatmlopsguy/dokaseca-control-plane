# CNI Wrapper Module
# This module dynamically loads the appropriate CNI sub-module based on var.kubernetes_cni

locals {
  cni = lower(var.kubernetes_cni)
}

# Calico CNI
module "calico" {
  source = "./calico"
  count  = local.cni == "calico" ? 1 : 0

  calico_version  = var.cni_version
  kubeconfig_path = var.kubeconfig_path
  wait_timeout    = var.wait_timeout
  wait_for_ready  = var.wait_for_ready
}

# Cilium CNI
module "cilium" {
  source = "./cilium"
  count  = local.cni == "cilium" ? 1 : 0

  helm_version = var.cni_version
}

# # Flannel CNI
# module "flannel" {
#   source = "./flannel"
#   count  = local.cni == "flannel" ? 1 : 0

#   flannel_version = var.cni_version
# }

# # Istio CNI
# module "istio" {
#   source = "./istio"
#   count  = local.cni == "istio" ? 1 : 0

#   istio_version = var.cni_version
# }
