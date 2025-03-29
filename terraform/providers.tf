terraform {
  required_providers {
    kind = {
      source  = "tehcyx/kind"
      version = "0.7.0"
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
      source = "gavinbunney/kubectl"
      version = "1.19.0"
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
