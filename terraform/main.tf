resource "kind_cluster" "main" {
  # count = var.kubernetes_distro == "kind" ? 1 : 0

  name            = "${var.cluster_type}-${var.environment}"
  kubeconfig_path = local.kubeconfig_path
  node_image      = "kindest/node:v${var.kubernetes_version}"
  wait_for_ready  = true

  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"
    node {
      role = "control-plane"

      # required for capd
      extra_mounts {
        host_path      = "/var/run/docker.sock"
        container_path = "/var/run/docker.sock"
      }

      kubeadm_config_patches = [
        "kind: InitConfiguration\nnodeRegistration:\n  kubeletExtraArgs:\n    node-labels: \"ingress-ready=true\"\n"
      ]

      # extra_port_mappings {
      #   container_port = 80
      #   host_port      = 80
      # }

      # extra_port_mappings {
      #   container_port = 443
      #   host_port      = 443
      # }
    }

    node {
      role = "worker"
    }
  }
}

# module "kind_cluster" {
#   source = "./modules/kind"

#   cluster_name       = var.cluster_name
#   environment        = var.environment
#   kubernetes_version = var.kubernetes_version
#   kubeconfig_path    = local.kubeconfig_path
# }


module "gitops_bridge_bootstrap" {
  source = "git::https://github.com/gitops-bridge-dev/terraform-helm-gitops-bridge?ref=33c09eb68af1ee673040bde58c3188383c46c288"

  count = var.enable_gitops_bridge ? 1 : 0

  cluster = {
    cluster_name = local.kubernetes_name
    environment  = local.environment
    metadata     = local.addons_metadata
    addons       = local.addons
  }

  argocd = {
    chart         = "argo-cd"
    chart_version = var.argocd_chart_version

    values = [local.argocd_helm_values]
  }

  apps = local.argocd_apps

  depends_on = [kind_cluster.main]
}

module "fluxcd" {
  source = "./modules/fluxcd"

  count = var.enable_fluxcd ? 1 : 0

  namespace     = var.fluxcd_namespace
  chart_version = var.fluxcd_chart_version

  repository_url     = "${var.gitops_org}/${var.gitops_addons_repo}"
  repository_branch  = var.gitops_addons_revision
  kustomization_path = "./gitops/fluxcd/addons/"

  depends_on = [kind_cluster.main]
}

# ArgoCD has support for OCI repos
# resource "kubernetes_secret" "kro_helm_oci" {
#   count = var.addons.enable_kro && var.enable_gitops_bridge ? 1 : 0

#   metadata {
#     name      = "kro-helm-oci"
#     namespace = "argocd"
#     labels = {
#       "argocd.argoproj.io/secret-type" = "repository"
#     }
#   }

#   data = {
#     url       = "ghcr.io/kro-run/kro/kro"
#     name      = "kro"
#     type      = "helm"
#     enableOCI = "true"
#   }

#   depends_on = [module.gitops_bridge_bootstrap]
# }

# resource "kubernetes_secret" "grafana_helm_oci" {
#   count = var.addons.enable_grafana_operator && var.enable_gitops_bridge ? 1 : 0

#   metadata {
#     name      = "grafana-helm-oci"
#     namespace = "argocd"
#     labels = {
#       "argocd.argoproj.io/secret-type" = "repository"
#     }
#   }

#   data = {
#     url       = "ghcr.io/grafana/helm-charts"
#     name      = "grafana"
#     type      = "helm"
#     enableOCI = "true"
#   }

#   depends_on = [module.gitops_bridge_bootstrap]
# }

# resource "kubernetes_secret" "logging_operator_helm_oci" {
#   count = var.addons.enable_logging_operator && var.enable_gitops_bridge ? 1 : 0

#   metadata {
#     name      = "logging-operator-helm-oci"
#     namespace = "argocd"
#     labels = {
#       "argocd.argoproj.io/secret-type" = "repository"
#     }
#   }

#   data = {
#     url       = "ghcr.io/kube-logging/helm-charts"
#     name      = "logging-operator"
#     type      = "helm"
#     enableOCI = "true"
#   }

#   depends_on = [module.gitops_bridge_bootstrap]
# }

# resource "kubernetes_secret" "strimzi_kafka_operator_helm_oci" {
#   count = var.addons.enable_strimzi && var.enable_gitops_bridge ? 1 : 0

#   metadata {
#     name      = "strimzi-kafka-operator-helm-oci"
#     namespace = "argocd"
#     labels = {
#       "argocd.argoproj.io/secret-type" = "repository"
#     }
#   }

#   data = {
#     url       = "quay.io/strimzi-helm"
#     name      = "strimzi-kafka-operator"
#     type      = "helm"
#     enableOCI = "true"
#   }

#   depends_on = [module.gitops_bridge_bootstrap]
# }

# resource "kubernetes_secret" "kargo_helm_oci" {
#   count = var.addons.enable_kargo && var.enable_gitops_bridge ? 1 : 0

#   metadata {
#     name      = "kargo-helm-oci"
#     namespace = "argocd"
#     labels = {
#       "argocd.argoproj.io/secret-type" = "repository"
#     }
#   }

#   data = {
#     url       = "ghcr.io/akuity/kargo-charts"
#     name      = "kargo"
#     type      = "helm"
#     enableOCI = "true"
#   }

#   depends_on = [module.gitops_bridge_bootstrap]
# }
