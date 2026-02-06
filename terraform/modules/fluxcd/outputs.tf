output "release_name" {
  value       = helm_release.flux_operator.name
  description = "Name of the Helm release"
}
