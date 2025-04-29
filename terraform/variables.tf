variable "environment" {
  description = "Name of the environment"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "stg", "prod"], lower(var.environment))
    error_message = "Invalid environment. Must be one of 'dev', 'stg' or 'prod'."
  }
}

variable "region" {
  description = "region of the kubernetes cluster"
  type        = string
  default     = "north-america"

  validation {
    condition     = contains(["north-america", "europe", "asia-pacific"], lower(var.region))
    error_message = "Invalid environment. Must be one of 'north-america', 'europe' or 'asia-pacific'."
  }
}

variable "cluster_name" {
  description = "Name of the kubernetes cluster"
  type        = string
  default     = "main"
}

variable "domain_name" {
  description = "Domain name"
  type        = string
  default     = "k8s-home.lab"
}

variable "kubernetes_distro" {
  description = "Name of the kubernetes distro"
  type        = string
  default     = "kind"

  validation {
    condition     = contains(["kind", "k3d", "k0s"], lower(var.kubernetes_distro))
    error_message = "Invalid kubernetes distro. Must be one of 'kind', 'k3d' or 'k0s'."
  }
}

variable "kubernetes_version" {
  description = "Version of the Kind node image"
  type        = string
  default     = "v1.31.2"
}

variable "cloud_provider" {
  type        = string
  description = "Cloud provider to deploy infrastructure to"
  default     = "local"

  validation {
    condition     = contains(["aws", "azure", "gcp", "local"], lower(var.cloud_provider))
    error_message = "Invalid cloud provider. Must be one of 'local', 'aws', 'azure' or 'gcp'."
  }
}

variable "enable_gitops_bridge" {
  description = "Enable gitops bridge"
  type        = bool
  default     = true
}

variable "enable_fluxcd" {
  description = "Enable fluxcd"
  type        = bool
  default     = false
}

variable "argocd_files_config" {
  type = object({
    load_addons    = bool
    load_workloads = bool
    load_clusters  = bool
  })
  default = {
    load_addons    = true
    load_workloads = true
    load_clusters  = true
  }
}

variable "fluxcd_namespace" {
  description = "Kubernetes namespace to deploy Flux2 in"
  type        = string
  default     = "flux-system"
}

variable "fluxcd_chart_version" {
  description = "fluxcd helm chart version"
  type        = string
  default     = "2.15.0"
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
    # dashboard
    enable_headlamp                = false
    enable_helm_dashboard          = false
    enable_komoplane               = false
    enable_argo_cd                 = true
    enable_argo_cd_image_updater   = true
    enable_gitops_promoter         = false
    enable_argo_rollouts           = true
    enable_argo_workflows          = true
    enable_argo_events             = false
    enable_kargo                   = false
    enable_keptn                   = false
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
    enable_opencost                = false
    enable_grafana_operator        = true
    enable_polaris                 = false
    enable_devlake                 = false
    enable_strimzi                 = false
    enable_open_feature            = false
    enable_istio                   = false
    enable_reloader                = false
    enable_karpor                  = false
    enable_backstage               = false
    enable_kubescape               = false
    enable_victoria_logs           = false
    enable_mlflow                  = false
    enable_kuberay                 = false
    enable_seldon                  = false
  }
}

# Addons Git
variable "gitops_org" {
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

variable "backstage_github_token" {
  description = "Backstage github token"
  type        = string
  default     = "TODO"
}
