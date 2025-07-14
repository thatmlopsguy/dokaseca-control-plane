terraform {
  required_providers {
    kind = {
      source  = "tehcyx/kind"
      version = "0.8.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "2.17.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.35.1"
    }

    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.19.0"
    }

    vault = {
      source  = "hashicorp/vault"
      version = "5.1.0"
    }
  }
}

provider "kind" {
}

provider "kubernetes" {
  config_path = kind_cluster.main.kubeconfig_path
}

provider "helm" {
  kubernetes {
    config_path = kind_cluster.main.kubeconfig_path
  }
}

provider "kubectl" {
}

provider "vault" {
  # The Vault provider does not require any configuration
  # by default, it will use the environment variables
  # VAULT_ADDR and VAULT_TOKEN to connect to Vault.
  # If you need to specify a different address or token,
  # you can do so here.
  # address = "https://vault.example.com"
  # token = "s.your-vault-token"
  # If you are using Vault with TLS, you may also need to
  # specify the CA certificate or disable TLS verification.
  # ca_cert = "/path/to/ca.pem"
  # skip_tls_verify = true
  # If you are using Vault with a specific namespace,
  # you can specify it here.
  # namespace = "your-namespace"
  # If you are using Vault with a specific auth method,
  # you can specify it here.
  # auth_method = "your-auth-method"
}
