variable "cluster_name" {
  description = "Name of the Kind cluster"
  type        = string
  default     = "main"
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
  default     = "v1.31.2"
}


variable "kubeconfig_path" {
  description = "Path to save the kubeconfig"
  type        = string
}
