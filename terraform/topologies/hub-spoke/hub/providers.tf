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
  }
}

provider "kind" {
}

provider "kubernetes" {
  host                   = module.kind_cluster.cluster_endpoint
  client_certificate     = module.kind_cluster.client_certificate
  client_key             = module.kind_cluster.client_key
  cluster_ca_certificate = module.kind_cluster.cluster_ca_certificate
}

provider "helm" {
  kubernetes {
    host                   = module.kind_cluster.cluster_endpoint
    client_certificate     = module.kind_cluster.client_certificate
    client_key             = module.kind_cluster.client_key
    cluster_ca_certificate = module.kind_cluster.cluster_ca_certificate
  }
}

provider "kubectl" {
  host                   = module.kind_cluster.cluster_endpoint
  client_certificate     = module.kind_cluster.client_certificate
  client_key             = module.kind_cluster.client_key
  cluster_ca_certificate = module.kind_cluster.cluster_ca_certificate
  load_config_file       = false
}

