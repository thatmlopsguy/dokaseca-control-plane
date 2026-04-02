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
  default     = "local"

  validation {
    condition     = contains(["local", "eu", "apac", "us"], lower(var.region))
    error_message = "Invalid environment. Must be one of 'local', 'eu', 'apac' or 'us'."
  }
}

variable "create" {
  description = "Create terraform resources"
  type        = bool
  default     = true
}

variable "argocd" {
  description = "argocd helm options"
  type        = any
  default     = {}
}

variable "install" {
  description = "Deploy argocd helm"
  type        = bool
  default     = true
}

variable "cluster" {
  description = "argocd cluster secret"
  type        = any
  default     = null
}

variable "apps" {
  description = "argocd app of apps to deploy"
  type        = any
  default     = {}
}
