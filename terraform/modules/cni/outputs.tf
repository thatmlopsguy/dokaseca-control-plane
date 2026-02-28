# CNI Wrapper Module Outputs
output "cni_type" {
  description = "The CNI plugin type that was deployed"
  value       = var.kubernetes_cni
}

output "cni_enabled" {
  description = "Whether a CNI plugin was deployed (false if 'default')"
  value       = lower(var.kubernetes_cni) != "default"
}

# Calico outputs
output "calico_version" {
  description = "The version of Calico deployed (if Calico is the selected CNI)"
  value       = local.cni == "calico" && length(module.calico) > 0 ? module.calico[0].calico_version : null
}

output "calico_tigera_operator_url" {
  description = "The URL of the Tigera Operator manifest (if Calico is the selected CNI)"
  value       = local.cni == "calico" && length(module.calico) > 0 ? module.calico[0].tigera_operator_url : null
}

output "calico_custom_resources_url" {
  description = "The URL of the Calico custom resources manifest (if Calico is the selected CNI)"
  value       = local.cni == "calico" && length(module.calico) > 0 ? module.calico[0].custom_resources_url : null
}
