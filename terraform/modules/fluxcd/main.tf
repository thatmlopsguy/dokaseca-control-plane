# This module installs FluxCD using the flux-operator and
# flux-instance charts from the ControlPlaneIO FluxCD repository.
# https://github.com/controlplaneio-fluxcd/flux-operator/blob/main/config/terraform/README.md

// Create the  flux-system namespace.
resource "kubernetes_namespace" "flux_system" {
  metadata {
    name = var.namespace
  }

  lifecycle {
    ignore_changes = [metadata]
  }
}

// Create a Kubernetes secret with the Git credentials
// if a GitHub/GitLab token or GitHub App is provided.
resource "kubernetes_secret" "git_auth" {
  count      = var.git_token != "" || var.github_app_id != "" ? 1 : 0
  depends_on = [kubernetes_namespace.flux_system]

  metadata {
    name      = var.namespace
    namespace = var.namespace
  }

  data = {
    username                   = var.git_token != "" ? "git" : null
    password                   = var.git_token != "" ? var.git_token : null
    githubAppID                = var.github_app_id != "" ? var.github_app_id : null
    githubAppInstallationOwner = var.github_app_installation_owner != "" ? var.github_app_installation_owner : null
    githubAppPrivateKey        = var.github_app_pem != "" ? var.github_app_pem : null
  }

  type = "Opaque"
}

// Install the Flux Operator.
resource "helm_release" "flux_operator" {
  name             = "flux-operator"
  namespace        = var.namespace
  repository       = "oci://ghcr.io/controlplaneio-fluxcd/charts"
  chart            = "flux-operator"
  create_namespace = true
}

// Deploy the Flux instance.
resource "helm_release" "flux_instance" {
  name       = "flux"
  namespace  = var.namespace
  repository = "oci://ghcr.io/controlplaneio-fluxcd/charts"
  chart      = "flux-instance"

  // Configure the Flux components and kustomize patches.
  values = [
    file("${path.module}/values/components.yaml")
  ]

  // Configure the Flux distribution, cluster type and Git sync.
  set {
    name  = "instance.distribution.version"
    value = var.flux_version
  }

  set {
    name  = "instance.distribution.registry"
    value = var.flux_registry
  }

  set {
    name  = "instance.cluster.type"
    value = var.cluster_type
  }

  set {
    name  = "instance.cluster.size"
    value = var.cluster_size
  }

  set {
    name  = "instance.sync.kind"
    value = "GitRepository"
  }

  set {
    name  = "instance.sync.url"
    value = var.git_url
  }

  set {
    name  = "instance.sync.path"
    value = var.git_path
  }

  set {
    name  = "instance.sync.ref"
    value = var.git_ref
  }

  set {
    name  = "instance.sync.provider"
    value = var.github_app_id != "" ? "github" : "generic"
  }

  set {
    name  = "instance.sync.pullSecret"
    value = var.git_token != "" || var.github_app_id != "" ? "flux-system" : ""
  }

  set {
    name  = "healthcheck.enabled"
    value = "true"
    type  = "auto"
  }

  depends_on = [helm_release.flux_operator]
}
