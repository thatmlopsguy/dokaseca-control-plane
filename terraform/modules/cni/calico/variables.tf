variable "calico_version" {
  description = "The version of Calico to deploy"
  type        = string
  default     = "v3.26.1"

  validation {
    condition     = can(regex("^v?\\d+\\.\\d+\\.\\d+$", var.calico_version))
    error_message = "The Calico version must be in the format 'vX.Y.Z' or 'X.Y.Z'"
  }
}

variable "kubeconfig_path" {
  description = "Path to the kubeconfig file"
  type        = string

  validation {
    condition     = length(var.kubeconfig_path) > 0
    error_message = "The kubeconfig path must not be empty"
  }
}

variable "wait_timeout" {
  description = "Timeout for waiting for resources to be ready"
  type        = string
  default     = "300s"
}

variable "wait_for_ready" {
  description = "Whether to wait for Calico to be fully ready after deployment"
  type        = bool
  default     = true
}
