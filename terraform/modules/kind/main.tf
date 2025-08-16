resource "kind_cluster" "main" {
  name            = var.cluster_name
  kubeconfig_path = var.kubeconfig_path
  node_image      = "kindest/node:v${var.kubernetes_version}"
  wait_for_ready  = true

  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"
    node {
      role = "control-plane"

      dynamic "extra_mounts" {
        for_each = var.extra_mounts
        content {
          host_path      = extra_mounts.value.host_path
          container_path = extra_mounts.value.container_path
        }
      }

      kubeadm_config_patches = [
        "kind: InitConfiguration\nnodeRegistration:\n  kubeletExtraArgs:\n    node-labels: \"ingress-ready=true\"\n",
        #"kind: ClusterConfiguration\ncontrollerManager:\n  extraArgs:\n    bind-address: \"0.0.0.0\"\nscheduler:\n  extraArgs:\n    bind-address: \"0.0.0.0\"\n"
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

    # Commenting out worker node due to persistent kubeadm join issues
    # Using single-node cluster with untainted control-plane instead
    # node {
    #   role = "worker"
    # }
  }
}

# # Remove NoSchedule taint from control-plane to allow workload scheduling
# resource "null_resource" "remove_control_plane_taint" {
#   depends_on = [kind_cluster.main]

#   provisioner "local-exec" {
#     command = "kubectl --kubeconfig ${var.kubeconfig_path} taint nodes --all node-role.kubernetes.io/control-plane- || true"
#   }
# }
