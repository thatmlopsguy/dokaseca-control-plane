output "cluster_name" {
  description = "The name of the KIND cluster"
  value       = kind_cluster.main.name
}

output "cluster_endpoint" {
  description = "The endpoint of the KIND cluster"
  value       = kind_cluster.main.endpoint
}

output "kubeconfig_path" {
  description = "The path to the kubeconfig file for this cluster"
  value       = kind_cluster.main.kubeconfig_path
}

output "client_certificate" {
  description = "The client certificate for the KIND cluster"
  value       = kind_cluster.main.client_certificate
  sensitive   = true
}

output "client_key" {
  description = "The client key for the KIND cluster"
  value       = kind_cluster.main.client_key
  sensitive   = true
}

output "cluster_ca_certificate" {
  description = "The cluster CA certificate for the KIND cluster"
  value       = kind_cluster.main.cluster_ca_certificate
  sensitive   = true
}
