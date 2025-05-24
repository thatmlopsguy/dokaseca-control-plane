resource "kind_cluster" "main" {
  # count = var.kubernetes_distro == "kind" ? 1 : 0

  name            = "${var.cluster_name}-${var.environment}"
  kubeconfig_path = var.kubeconfig_path
  node_image      = "kindest/node:v${var.kubernetes_version}"
  wait_for_ready  = true

  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"
    node {
      role = "control-plane"

      # extra_mounts {
      #   host_path      = "/var/run/docker.sock"
      #   container_path = "/var/run/docker.sock"
      # }

      kubeadm_config_patches = [
        "kind: InitConfiguration\nnodeRegistration:\n  kubeletExtraArgs:\n    node-labels: \"ingress-ready=true\"\n"
      ]

      # extra_port_mappings {
      #   container_port = 80
      #   host_port      = 80
      # }

      # extra_port_mappings {
      #   container_port = 443
      #   host_port      = 443
      # }
    }

    node {
      role = "worker"
    }
  }
}
