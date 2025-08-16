module "kind_cluster" {
  source = "./../../modules/kind"

  cluster_name       = local.kubernetes_name
  cluster_type       = var.cluster_type
  environment        = var.environment
  kubernetes_version = var.kubernetes_version
  kubeconfig_path    = local.kubeconfig_path
}

# Kubernetes Access for Hub Cluster
data "terraform_remote_state" "cluster_hub" {
  backend = "local"

  config = {
    path = "${path.module}/../hub/terraform.tfstate"
  }
}

provider "kubernetes" {
  host                   = data.terraform_remote_state.cluster_hub.outputs.cluster_endpoint
  client_certificate     = data.terraform_remote_state.cluster_hub.outputs.client_certificate
  client_key             = data.terraform_remote_state.cluster_hub.outputs.client_key
  cluster_ca_certificate = data.terraform_remote_state.cluster_hub.outputs.cluster_ca_certificate

  alias = "hub"
}
