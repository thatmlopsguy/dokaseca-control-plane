variable "cluster_name" {
  description = "Name of the k3d cluster"
  type        = string
}

variable "k3d_version" {
  description = "Version of k3d to install"
  type        = string
  default     = "latest"
}

variable "k3s_version" {
  description = "Version of k3s to use"
  type        = string
  default     = "v1.31.5-k3s1"
}

variable "servers" {
  description = "Number of server nodes"
  type        = number
  default     = 1
}

variable "agents" {
  description = "Number of agent nodes"
  type        = number
  default     = 2
}

variable "ports" {
  description = "List of port mappings"
  type = list(object({
    host_port      = number
    container_port = number
    protocol       = string
  }))
  default = []
}

variable "volume_mounts" {
  description = "List of volume mounts"
  type = list(object({
    host_path      = string
    container_path = string
  }))
  default = []
}

variable "disabled_components" {
  description = "Components to disable in k3s"
  type        = list(string)
  default     = ["traefik", "metrics-server"]
}
