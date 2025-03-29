resource "helm_release" "flux2" {
  name = "flux2"

  chart     = "oci://ghcr.io/fluxcd-community/charts/flux2"
  namespace = var.namespace
  version   = var.chart_version

  create_namespace = true
}

resource "kubectl_manifest" "git_repository" {
  yaml_body = yamlencode({
    apiVersion = "source.toolkit.fluxcd.io/v1"
    kind       = "GitRepository"
    metadata = {
      name      = "addons"
      namespace = "flux-system"
    }
    spec = {
      interval = "5m"
      url      = var.repository_url
      ref = {
        branch = var.repository_branch
      }
    }
  })

  depends_on = [helm_release.flux2]
}

resource "kubectl_manifest" "kustomization" {
  yaml_body = yamlencode({
    apiVersion = "kustomize.toolkit.fluxcd.io/v1"
    kind       = "Kustomization"
    metadata = {
      name      = "addons"
      namespace = "flux-system"
    }
    spec = {
      interval        = "10m"
      targetNamespace = "flux-system"
      sourceRef = {
        kind      = "GitRepository"
        name      = "addons"
        namespace = "flux-system"
      }
      path    = var.kustomization_path
      prune   = true
      timeout = "1m"
    }
  })

  depends_on = [kubectl_manifest.git_repository]
}
