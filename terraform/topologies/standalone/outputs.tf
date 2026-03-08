output "cluster_name" {
  description = "The name of the cluster"
  value       = try(one(module.kind_cluster[*].cluster_name), one(module.vind_cluster[*].cluster_name), null)
}

output "cluster_endpoint" {
  description = "The endpoint of the cluster"
  value       = try(one(module.kind_cluster[*].cluster_endpoint), null)
}

output "kubeconfig_path" {
  description = "The path to the kubeconfig file for this cluster"
  value       = try(one(module.kind_cluster[*].kubeconfig_path), one(module.vind_cluster[*].kubeconfig_path), null)
}

output "client_certificate" {
  description = "The client certificate data for this cluster"
  value       = try(one(module.kind_cluster[*].client_certificate), null)
  sensitive   = true
}

output "client_key" {
  description = "The client key data for this cluster"
  value       = try(one(module.kind_cluster[*].client_key), null)
  sensitive   = true
}

output "cluster_ca_certificate" {
  description = "The cluster CA certificate data for this cluster"
  value       = try(one(module.kind_cluster[*].cluster_ca_certificate), null)
  sensitive   = true
}
