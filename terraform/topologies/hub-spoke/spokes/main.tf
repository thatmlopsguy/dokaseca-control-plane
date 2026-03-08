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

# Get the container IP for the spoke cluster using external data source
data "external" "spoke_container_ip" {
  program = ["sh", "-c", "docker inspect ${module.kind_cluster.cluster_name}-control-plane --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' | jq -R '{ip: .}'"]
}

# GitOps Bridge: Bootstrap for Hub Cluster
# The ArgoCD remote cluster secret is deploy on hub cluster not on spoke clusters
module "gitops_bridge_bootstrap_hub" {
  source = "git::https://github.com/gitops-bridge-dev/terraform-helm-gitops-bridge?ref=33c09eb68af1ee673040bde58c3188383c46c288"

  providers = {
    kubernetes = kubernetes.hub
  }

  install = false # We are not installing argocd via helm on hub cluster
  cluster = {
    cluster_name = module.kind_cluster.cluster_name
    environment  = local.env
    metadata     = local.addons_metadata
    addons       = local.addons
    server       = "https://${data.external.spoke_container_ip.result.ip}:6443"
    config = jsonencode({
      "tlsClientConfig" = {
        "insecure" = false
        "caData"   = base64encode(module.kind_cluster.cluster_ca_certificate)
        "certData" = base64encode(module.kind_cluster.client_certificate)
        "keyData"  = base64encode(module.kind_cluster.client_key)
      }
    })
  }
}
