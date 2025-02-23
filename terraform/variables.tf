variable "cluster_name" {
  description = "Name of the Kind cluster"
  type        = string
  default     = "main"
}

variable "kubernetes_version" {
  description = "Version of the Kind node image"
  type        = string
  default     = "v1.31.2"
}

variable "enable_gitops_bridge" {
  description = "Enable gitops bridge"
  type        = bool
  default     = true
}

variable "argocd_chart_version" {
  description = "Argocd helm chart version"
  type        = string
  default     = "7.8.2"
}

variable "addons" {
  description = "Kubernetes addons"
  type        = any
  default = {
    enable_argo_cd                 = true
    enable_argo_cd_image_updater   = true
    enable_argo_rollouts           = true
    enable_argo_workflows          = true
    enable_argo_events             = false
    enable_cert_manager            = true
    enable_external_secrets        = true
    enable_velero                  = true
    enable_kube_prometheus_stack   = true
    enable_metrics_server          = true
    enable_keda                    = true
    enable_dapr                    = true
    enable_trivy                   = true
    enable_kro                     = false
    enable_kyverno                 = false
    enable_kyverno_policies        = false
    enable_kyverno_policy_reporter = false
    enable_capi_operator           = true # requires enable_cert_manager
    enable_cilium                  = false
    enable_calico                  = false
    enable_metallb                 = false
    enable_ingress_nginx           = true
    enable_ngrok                   = false
    enable_cilium                  = false
    enable_ray_operator            = false
    enable_promtail                = false
    enable_opencost                = false
    enable_grafana_operator        = true
    enable_polaris                 = false
    enable_devlake                 = false
    enable_strimzi                 = false
  }
}

# Addons Git
variable "gitops_addons_org" {
  description = "Git repository org/user contains for addons"
  type        = string
  default     = "https://github.com/gitops-bridge-dev"
}

variable "gitops_addons_repo" {
  description = "Git repository contains for addons"
  type        = string
  default     = "gitops-bridge-argocd-control-plane-template"
}

variable "gitops_addons_revision" {
  description = "Git repository revision/branch/ref for addons"
  type        = string
  default     = "main"
}

variable "gitops_addons_basepath" {
  description = "Git repository base path for addons"
  type        = string
  default     = "gitops"
}

variable "gitops_addons_path" {
  description = "Git repository path for addons"
  type        = string
  default     = "addons"
}

# Addon Resources Git
variable "gitops_resources_org" {
  description = "Git repository org/user contains for addon resources"
  type        = string
  default     = "https://github.com/gitops-bridge-dev"
}

variable "gitops_resources_repo" {
  description = "Git repository contains for addon resources"
  type        = string
  default     = "gitops-bridge-argocd-control-plane-template"
}

variable "gitops_resources_basepath" {
  description = "Git repository base path for addon resources"
  type        = string
  default     = "gitops"
}

variable "gitops_resources_revision" {
  description = "Git repository revision/branch/ref for addon resources"
  type        = string
  default     = "main"
}

# Workloads Git
variable "gitops_workload_org" {
  description = "Git repository org/user contains for workload"
  type        = string
  default     = "https://github.com/gitops-bridge-dev"
}

variable "gitops_workload_repo" {
  description = "Git repository contains for workload"
  type        = string
  default     = "gitops-bridge"
}

variable "gitops_workload_basepath" {
  description = "Git repository base path for workload"
  type        = string
  default     = "argocd/iac/terraform/examples/eks/"
}

variable "gitops_workload_path" {
  description = "Git repository path for workload"
  type        = string
  default     = "karpenter/k8s"
}

variable "gitops_workload_revision" {
  description = "Git repository revision/branch/ref for workload"
  type        = string
  default     = "main"
}

# Clusters Git
variable "gitops_cluster_org" {
  description = "Git repository org/user contains for clusters"
  type        = string
  default     = "https://github.com/gitops-bridge-dev"
}

variable "gitops_cluster_repo" {
  description = "Git repository contains for clusters"
  type        = string
  default     = "gitops-bridge"
}

variable "gitops_cluster_basepath" {
  description = "Git repository base path for clusters"
  type        = string
  default     = "argocd/iac/terraform/examples/eks/"
}

variable "gitops_cluster_path" {
  description = "Git repository path for clusters"
  type        = string
  default     = "karpenter/k8s"
}

variable "gitops_cluster_revision" {
  description = "Git repository revision/branch/ref for clusters"
  type        = string
  default     = "main"
}
