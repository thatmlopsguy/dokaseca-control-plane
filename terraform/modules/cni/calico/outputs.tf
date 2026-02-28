output "calico_version" {
  description = "The version of Calico deployed"
  value       = var.calico_version
}

output "tigera_operator_url" {
  description = "The URL of the Tigera Operator manifest"
  value       = local.tigera_operator_url
}

output "custom_resources_url" {
  description = "The URL of the Calico custom resources manifest"
  value       = local.calico_custom_resources_url
}
