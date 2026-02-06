output "cluster_name" {
  description = "The name of the KIND cluster"
  value       = module.kind_cluster.cluster_name
}

output "cluster_endpoint" {
  description = "The endpoint of the KIND cluster"
  value       = module.kind_cluster.cluster_endpoint
}

output "kubeconfig_path" {
  description = "The path to the kubeconfig file for this cluster"
  value       = module.kind_cluster.kubeconfig_path
}

output "client_certificate" {
  description = "The client certificate data for this cluster"
  value       = module.kind_cluster.client_certificate
  sensitive   = true
}

output "client_key" {
  description = "The client key data for this cluster"
  value       = module.kind_cluster.client_key
  sensitive   = true
}

output "cluster_ca_certificate" {
  description = "The cluster CA certificate data for this cluster"
  value       = module.kind_cluster.cluster_ca_certificate
  sensitive   = true
}
