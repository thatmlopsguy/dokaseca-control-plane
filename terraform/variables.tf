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

variable "addons" {
  description = "Kubernetes addons"
  type        = any
  default = {
    enable_argo_cd                               = true
    enable_argo_rollouts                         = true
    enable_argo_workflows                        = true
    enable_argo_events                           = false
    enable_cert_manager                          = true
    enable_external_secrets                      = true
    enable_velero                                = true
    enable_kube_prometheus_stack                 = true
    enable_metrics_server                        = true
    enable_dapr                                  = true
    # you can add any addon here, make sure to update the gitops repo with the corresponding application set
    enable_foo                                   = true
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
