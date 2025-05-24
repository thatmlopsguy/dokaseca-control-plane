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
