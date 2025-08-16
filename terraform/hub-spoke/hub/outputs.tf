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
