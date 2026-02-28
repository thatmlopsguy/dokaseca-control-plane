variable "cluster_name" {
  type        = string
  default     = "local-cluster"
  description = "Defines the name of the cluster"
  validation {
    condition     = length(var.cluster_name) > 0
    error_message = "The cluster name must not be empty"
  }
}

variable "kubernetes_version" {
  type        = string
  default     = "1.35.1"
  description = "Defines the kubernetes version to be used"
  validation {
    condition     = can(regex("[0-9]+.[0-9]+.[0-9]+", var.kubernetes_version))
    error_message = "The Kubernetes version must be in the format 1.x.y"
  }
}

variable "worker_nodes" {
  type        = number
  default     = 1
  description = "Defines the number of worker nodes to be created"
  validation {
    condition     = var.worker_nodes > 0
    error_message = "The number of worker nodes must be at least 1"
  }
}

variable "kubeconfig_save_path" {
  description = "Defines the path to save the kubeconfig file"
  type        = string
  default     = "kubeconfig"

  validation {
    condition     = length(var.kubeconfig_save_path) > 0
    error_message = "The kubeconfig save path must not be empty"
  }
}

variable "enable_telemetry" {
  description = "Enable telemetry for the cluster"
  type        = bool
  default     = false
}

variable "enable_vcluster_platform" {
  description = "Enable VCluster Platform for the cluster. Required for private nodes"
  type        = bool
  default     = false
}

variable "enable_private_nodes" {
  description = "Enable private nodes for the cluster. Requires VCluster Platform to be enabled"
  type        = bool
  default     = false

  validation {
    condition     = !(var.enable_private_nodes && !var.enable_vcluster_platform)
    error_message = "Private nodes require VCluster Platform to be enabled"
  }
}

variable "enable_default_cni" {
  description = "Enable the default CNI (Flannel) for the cluster. Consider disabling this, if you want to use a different CNI plugin"
  type        = bool
  default     = true
}
