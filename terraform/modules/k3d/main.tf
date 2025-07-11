# Install k3d if not present
resource "null_resource" "install_k3d" {
  provisioner "local-exec" {
    command = <<EOF
      if ! command -v k3d &> /dev/null; then
        curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
      fi
    EOF
  }
}

# Create configuration file
resource "local_file" "cluster_config" {
  content = templatefile("${path.module}/config.tpl", {
    cluster_name = "${var.cluster_type}-${var.environment}"
    servers      = var.servers
    agents       = var.agents
    k3s_version  = var.k3s_version
    # ports         = var.ports
    # volume_mounts = var.volume_mounts
    # disabled      = var.disabled_components
  })
  filename = "${path.module}/${var.cluster_type}.yaml"
}

# Create k3d cluster
resource "null_resource" "k3d_cluster" {
  depends_on = [
    null_resource.install_k3d,
    local_file.cluster_config
  ]

  provisioner "local-exec" {
    command = "k3d cluster create --config ${path.module}/${var.cluster_type}.yaml"
  }

  # Store cluster type in resource metadata for destroy phase
  provisioner "local-exec" {
    command = "echo '${var.cluster_type}' > ${path.module}/cluster-type.txt"
    when    = create
  }

  # Clean up temporary files
  provisioner "local-exec" {
    command = "k3d cluster delete $(cat ${path.module}/cluster-name.txt) && rm -f ${path.module}/cluster-name.txt"
    when    = destroy
  }
}
