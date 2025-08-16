variable "cluster_name" {
  description = "Name of the cluster"
  type        = string
}

variable "cluster_type" {
  description = "Type of the cluster, used in naming"
  type        = string
  default     = "hub"
  validation {
    condition     = contains(["hub", "spoke"], lower(var.cluster_type))
    error_message = "Invalid cluster type. Must be one of 'hub' or 'spoke'."
  }
}

variable "environment" {
  description = "Name of the environment"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "stg", "prod"], lower(var.environment))
    error_message = "Invalid environment. Must be one of 'dev', 'stg' or 'prod'."
  }
}

variable "kubernetes_version" {
  description = "Version of the Kind node image"
  type        = string
  default     = "1.31.2"
}

variable "kubeconfig_path" {
  description = "Path to save the kubeconfig"
  type        = string
}
