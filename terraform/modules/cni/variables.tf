variable "kubernetes_cni" {
  description = "Kubernetes CNI plugin to use"
  type        = string
  default     = "default"
  validation {
    condition     = contains(["default", "calico", "cilium", "flannel", "istio"], lower(var.kubernetes_cni))
    error_message = "Invalid kubernetes cni. Must be one of 'default', 'calico', 'cilium', 'flannel' or 'istio'."
  }
}

variable "kubeconfig_path" {
  description = "Path to the kubeconfig file"
  type        = string
  default     = ""

  validation {
    condition     = var.kubeconfig_path == "" || length(var.kubeconfig_path) > 0
    error_message = "The kubeconfig path must not be empty when CNI is not 'default'"
  }
}

variable "wait_timeout" {
  description = "Timeout for waiting for resources to be ready"
  type        = string
  default     = "300s"
}

variable "wait_for_ready" {
  description = "Whether to wait for CNI to be fully ready after deployment"
  type        = bool
  default     = true
}

# CNI-specific variables
variable "cni_version" {
  description = "The version of the CNI plugin to deploy"
  type        = string
}
