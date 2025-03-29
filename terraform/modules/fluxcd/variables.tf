variable "namespace" {
  description = "Kubernetes namespace to deploy Flux2 in"
  type        = string
  default     = "flux-system"
}

variable "chart_version" {
  description = "fluxcd helm chart version"
  type        = string
  default     = "2.15.0"
}

variable "repository_url" {
  description = "URL of the Git repository containing Kubernetes manifests"
  type        = string
}

variable "repository_branch" {
  description = "Branch to track in the Git repository"
  type        = string
  default     = "main"
}

variable "kustomization_path" {
  description = "Path within the repository to look for kustomization files"
  type        = string
}
