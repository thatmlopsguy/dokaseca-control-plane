output "release_name" {
  value       = helm_release.flux2.name
  description = "Name of the Helm release"
}
