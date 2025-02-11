locals {
  name        = "ex-${replace(basename(path.cwd), "_", "-")}"
  environment = "prod"

  cluster_name    = var.cluster_name
  cluster_version = var.kubernetes_version

  gitops_addons_url      = "${var.gitops_addons_org}/${var.gitops_addons_repo}"
  gitops_addons_basepath = var.gitops_addons_basepath
  gitops_addons_path     = var.gitops_addons_path
  gitops_addons_revision = var.gitops_addons_revision

  oss_addons = {
    enable_argo_cd                         = try(var.addons.enable_argo_cd, true)
    enable_argo_rollouts                   = try(var.addons.enable_argo_rollouts, false)
    enable_argo_events                     = try(var.addons.enable_argo_events, false)
    enable_argo_workflows                  = try(var.addons.enable_argo_workflows, false)
    enable_external_secrets                = try(var.addons.enable_external_secrets, false)
    enable_ingress_nginx                   = try(var.addons.enable_ingress_nginx, false)
    enable_keda                            = try(var.addons.enable_keda, false)
    enable_kyverno                         = try(var.addons.enable_kyverno, false)
    enable_kyverno_policies                = try(var.addons.enable_kyverno_policies, false)
    enable_kube_prometheus_stack           = try(var.addons.enable_kube_prometheus_stack, false)
    enable_metrics_server                  = try(var.addons.enable_metrics_server, false)
    enable_prometheus_adapter              = try(var.addons.enable_prometheus_adapter, false)
    enable_dapr                            = try(var.addons.enable_dapr, false)
    enable_trivy                           = try(var.addons.enable_trivy, false)
    enable_grafana_operator                = try(var.addons.enable_grafana_operator, false)
    enable_alloy                           = try(var.addons.enable_alloy, false)
    enable_chaos_mesh = try(var.addons.enable_chaos_mesh, false)
    enable_cloudnative_pg = try(var.addons.enable_cloudnative_pg, false)
    enable_connaisseur = try(var.addons.enable_connaisseur, false)
    # enable_cortex
    # enable_crossplane
    # enable_devlake
    # enable_flagsmith
    # enable_istio
    # enable_kiali
    # enable_jaeger
    # enable_kargo
    # enable_kepler
    # enable_keptn
    # enable_loki
    # enable_promtail
    # enable_fluentbit
    # enable_fluentd
    # enable_metallb
    # enable_minio
    # enable_open_feature
    # enable_opentelemetry_operator
    # enable_opencost
    # enable_openfunction
    # enable_pyroscope
    # enable_polaris
    # enable_pyrra
    # enable_reloader
    # enable_sealed_secrets
    # enable_sloth
    # enable_strimzi
    # enable_tempo
    # enable_thanos
    # enable_traefik
    # enable_vault
    # enable_vcluster
    # enable_vector
    # enable_zipkin
  }
  addons = merge(
    local.oss_addons,
    { kubernetes_version = local.cluster_version },
    { k8s_cluster_name = local.cluster_name }
  )

  addons_metadata = merge(
    {
      addons_repo_url      = local.gitops_addons_url
      addons_repo_basepath = local.gitops_addons_basepath
      addons_repo_path     = local.gitops_addons_path
      addons_repo_revision = local.gitops_addons_revision
    }
  )

  argocd_apps = {
    addons    = file("${path.module}/bootstrap/addons.yaml")
    # workloads = file("${path.module}/bootstrap/workloads.yaml")
  }

  tags = {
    Blueprint  = local.name
    GithubRepo = "github.com/thatmlopsguy/k8s-homelab"
  }
}
