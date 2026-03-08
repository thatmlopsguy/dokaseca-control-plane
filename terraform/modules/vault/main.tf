resource "kubernetes_namespace" "external_secrets" {
  count = var.manage_namespace ? 1 : 0

  metadata {
    name = "external-secrets"
  }

  lifecycle {
    prevent_destroy = true
  }
}

# Create a Kubernetes secret containing a Vault token for the External Secrets controller.
resource "kubernetes_secret" "vault_token" {
  count = var.vault_token != "" ? 1 : 0

  metadata {
    name      = var.vault_token_secret_name
    namespace = "external-secrets"
  }

  data = {
    token = var.vault_token
  }

  type = "Opaque"

  lifecycle {
    ignore_changes = [metadata]
  }
}

