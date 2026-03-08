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
  description = "Defines the name of the cluster"
  type        = string
  default     = "local-cluster"

  validation {
    condition     = length(var.cluster_name) > 0
    error_message = "The cluster name must not be empty"
  }
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

variable "kubernetes_version" {
  description = "Defines the kubernetes version to be used"
  type        = string
  default     = "1.35.1"

  validation {
    condition     = can(regex("[0-9]+.[0-9]+.[0-9]+", var.kubernetes_version))
    error_message = "The Kubernetes version must be in the format 1.x.y"
  }
}

variable "kubeconfig_path" {
  description = "Path to save the kubeconfig"
  type        = string
}

variable "extra_mounts" {
  description = "List of extra mounts to add to the control-plane node"
  type = list(object({
    host_path      = string
    container_path = string
  }))
  default = []
}

variable "worker_nodes" {
  description = "Defines the number of worker nodes to be created"
  type        = number
  default     = 1

  validation {
    condition     = var.worker_nodes > 0
    error_message = "The number of worker nodes must be at least 1"
  }
}

variable "disable_default_cni" {
  description = "If true, disables the default CNI (Container Network Interface) plugin in the kind cluster"
  type        = bool
  default     = false
}

variable "port_configuration" {
  description = "Defines the port mappings for the cluster nodes"
  type = map(object({
    app_protocol = string
    node_port    = number
    host_port    = number
    target_port  = number
    protocol     = string
  }))

  default = {
    http = {
      app_protocol = "http"
      node_port    = 30000
      host_port    = 80
      target_port  = 80
      protocol     = "TCP"
    }
    https = {
      app_protocol = "https"
      node_port    = 30001
      host_port    = 443
      target_port  = 443
      protocol     = "TCP"
    }
  }

  validation {
    condition     = length(var.port_configuration) == length(keys(var.port_configuration))
    error_message = "All port mapping keys must be unique"
  }

  validation {
    condition     = alltrue([for port in values(var.port_configuration) : length(port.app_protocol) > 0])
    error_message = "App Protocol must be a non-empty string"
  }

  validation {
    condition     = alltrue([for port in values(var.port_configuration) : port.node_port > 0 && port.node_port < 65536])
    error_message = "Node Port must be between 1 and 65535"
  }

  validation {
    condition     = alltrue([for port in values(var.port_configuration) : port.host_port > 0 && port.host_port < 65536])
    error_message = "Host Port must be between 1 and 65535"
  }

  validation {
    condition     = alltrue([for port in values(var.port_configuration) : port.target_port > 0 && port.target_port < 65536])
    error_message = "Target Port must be between 1 and 65535"
  }

  validation {
    condition     = alltrue([for port in values(var.port_configuration) : can(regex("TCP|UDP", port.protocol))])
    error_message = "Protocol must be either TCP or UDP"
  }
}
