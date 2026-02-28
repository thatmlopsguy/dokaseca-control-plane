output "cluster_name" {
  description = "The name of the VIND cluster"
  value       = var.cluster_name
}

output "kubeconfig_path" {
  description = "The path to the kubeconfig file for this cluster"
  value       = terraform_data.kubeconfig.triggers_replace.kubeconfig_path
}
