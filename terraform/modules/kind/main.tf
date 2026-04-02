# Ensure kubeconfig directory exists
resource "local_file" "kubeconfig_dir" {
  filename = "${dirname(var.kubeconfig_path)}/.gitkeep"
  content  = ""
}

resource "kind_cluster" "main" {
  depends_on      = [local_file.kubeconfig_dir]
  name            = var.cluster_name
  kubeconfig_path = var.kubeconfig_path
  node_image      = "kindest/node:v${var.kubernetes_version}"
  wait_for_ready  = true

  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"
    node {
      role = "control-plane"

      # Apply patch for Ingress
      kubeadm_config_patches = [<<-YAML
        kind: InitConfiguration
        nodeRegistration:
          kubeletExtraArgs:
            node-labels: "ingress-ready=true"
        YAML
      ]

      dynamic "extra_mounts" {
        for_each = var.extra_mounts
        content {
          host_path      = extra_mounts.value.host_path
          container_path = extra_mounts.value.container_path
        }
      }

      dynamic "extra_port_mappings" {
        for_each = var.port_configuration
        content {
          container_port = extra_port_mappings.value.node_port
          host_port      = extra_port_mappings.value.host_port
          protocol       = extra_port_mappings.value.protocol
        }
      }
    }

    dynamic "node" {
      for_each = range(var.worker_nodes)
      content {
        role = "worker"
      }
    }

    networking {
      disable_default_cni = var.disable_default_cni
    }
  }
}

# Write the kubeconfig to the specified path
resource "local_file" "kubeconfig" {
  depends_on      = [kind_cluster.main]
  content         = kind_cluster.main.kubeconfig
  filename        = var.kubeconfig_path
  file_permission = "0600"
}
