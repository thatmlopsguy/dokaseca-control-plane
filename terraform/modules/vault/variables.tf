variable "vault_token_secret_name" {
  description = "Name of the Kubernetes secret to create for the Vault token."
  type        = string
  default     = "vault-token"
}

variable "vault_token" {
  description = "A Vault token to create in the external-secrets namespace for the External Secrets operator to use. If empty, no secret will be created."
  type        = string
  sensitive   = true
}


