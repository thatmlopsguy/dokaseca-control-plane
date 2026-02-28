# This module installs Calico CNI using the Tigera Operator.
# https://docs.tigera.io/calico/latest/getting-started/kubernetes/quickstart

locals {
  calico_base_url             = "https://raw.githubusercontent.com/projectcalico/calico/${var.calico_version}/manifests"
  tigera_operator_url         = "${local.calico_base_url}/tigera-operator.yaml"
  calico_custom_resources_url = "${local.calico_base_url}/custom-resources.yaml"
}

# Deploy the Tigera Operator
resource "terraform_data" "tigera_operator_deploy" {
  input = {
    tigera_operator_url = local.tigera_operator_url
    kubeconfig_path     = var.kubeconfig_path
  }

  triggers_replace = {
    on_version_change   = var.calico_version
    tigera_operator_url = local.tigera_operator_url
    kubeconfig_path     = var.kubeconfig_path
  }

  provisioner "local-exec" {
    command = "kubectl apply -f ${local.tigera_operator_url} --kubeconfig=${var.kubeconfig_path}"
    environment = {
      "KUBECONFIG" = var.kubeconfig_path
    }
  }
}

# Destroy the Tigera Operator
resource "terraform_data" "tigera_operator_destroy" {
  input = {
    tigera_operator_url = local.tigera_operator_url
    kubeconfig_path     = var.kubeconfig_path
  }

  lifecycle {
    ignore_changes = [input]
  }

  provisioner "local-exec" {
    when    = destroy
    command = "kubectl delete -f ${self.input.tigera_operator_url} --kubeconfig=${self.input.kubeconfig_path} --ignore-not-found=true"
    environment = {
      "KUBECONFIG" = self.input.kubeconfig_path
    }
  }
}

# Wait for the Tigera Operator to be ready before applying custom resources
resource "terraform_data" "wait_for_operator" {
  depends_on = [terraform_data.tigera_operator_deploy]

  provisioner "local-exec" {
    command = <<-EOT
      kubectl wait --for=condition=Available deployment/tigera-operator \
        -n tigera-operator \
        --timeout=${var.wait_timeout} \
        --kubeconfig=${var.kubeconfig_path}
    EOT
    environment = {
      "KUBECONFIG" = var.kubeconfig_path
    }
  }
}

# Deploy Calico custom resources (Installation CRD)
resource "terraform_data" "calico_custom_resources_deploy" {
  depends_on = [terraform_data.wait_for_operator]

  input = {
    calico_custom_resources_url = local.calico_custom_resources_url
    kubeconfig_path             = var.kubeconfig_path
  }

  triggers_replace = {
    on_version_change           = var.calico_version
    calico_custom_resources_url = local.calico_custom_resources_url
    kubeconfig_path             = var.kubeconfig_path
  }

  provisioner "local-exec" {
    command = "kubectl apply -f ${local.calico_custom_resources_url} --kubeconfig=${var.kubeconfig_path}"
    environment = {
      "KUBECONFIG" = var.kubeconfig_path
    }
  }
}

# Destroy Calico custom resources
resource "terraform_data" "calico_custom_resources_destroy" {
  input = {
    calico_custom_resources_url = local.calico_custom_resources_url
    kubeconfig_path             = var.kubeconfig_path
  }

  lifecycle {
    ignore_changes = [input]
  }

  provisioner "local-exec" {
    when    = destroy
    command = "kubectl delete -f ${self.input.calico_custom_resources_url} --kubeconfig=${self.input.kubeconfig_path} --ignore-not-found=true"
    environment = {
      "KUBECONFIG" = self.input.kubeconfig_path
    }
  }
}

# Optionally wait for Calico to be fully ready
resource "terraform_data" "wait_for_calico" {
  count      = var.wait_for_ready ? 1 : 0
  depends_on = [terraform_data.calico_custom_resources_deploy]

  provisioner "local-exec" {
    command = <<-EOT
      kubectl wait --for=condition=Available tigerastatus/calico \
        --timeout=${var.wait_timeout} \
        --kubeconfig=${var.kubeconfig_path}
    EOT
    environment = {
      "KUBECONFIG" = var.kubeconfig_path
    }
  }
}
