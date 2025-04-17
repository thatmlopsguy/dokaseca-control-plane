locals {
  name        = "ex-${replace(basename(path.cwd), "_", "-")}"
  environment = "dev"

  cluster_name    = var.cluster_name
  cluster_version = var.kubernetes_version

  domain_name = var.domain_name

  gitops_addons_url      = "${var.gitops_addons_org}/${var.gitops_addons_repo}"
  gitops_addons_basepath = var.gitops_addons_basepath
  gitops_addons_path     = var.gitops_addons_path
  gitops_addons_revision = var.gitops_addons_revision

  gitops_resources_url      = "${var.gitops_resources_org}/${var.gitops_resources_repo}"
  gitops_resources_basepath = var.gitops_resources_basepath
  gitops_resources_revision = var.gitops_resources_revision

  gitops_workload_url      = "${var.gitops_workload_org}/${var.gitops_workload_repo}"
  gitops_workload_basepath = var.gitops_workload_basepath
  gitops_workload_path     = var.gitops_workload_path
  gitops_workload_revision = var.gitops_workload_revision

  gitops_cluster_url      = "${var.gitops_cluster_org}/${var.gitops_cluster_repo}"
  gitops_cluster_basepath = var.gitops_cluster_basepath
  gitops_cluster_path     = var.gitops_cluster_path
  gitops_cluster_revision = var.gitops_cluster_revision

  oss_addons = {
    # dashboard
    enable_headlamp = try(var.addons.enable_headlamp, false)
    # identity
    enable_authentik = try(var.addons.enable_authentik, true)
    enable_keycloak  = try(var.addons.enable_keycloak, true)
    enable_authelia  = try(var.addons.enable_authelia, true)
    # pipelines
    enable_argo_cd               = try(var.addons.enable_argo_cd, true)
    enable_argo_cd_image_updater = try(var.addons.enable_argo_cd_image_updater, true)
    enable_argo_rollouts         = try(var.addons.enable_argo_rollouts, false)
    enable_argo_events           = try(var.addons.enable_argo_events, false)
    enable_argo_workflows        = try(var.addons.enable_argo_workflows, false)
    enable_keda                  = try(var.addons.enable_keda, false)
    enable_keptn                 = try(var.addons.enable_keptn, false)
    enable_open_feature          = try(var.addons.enable_open_feature, false)
    enable_openfunction          = try(var.addons.enable_openfunction, false)
    enable_sloth                 = try(var.addons.enable_sloth, false)
    enable_capi_operator         = try(var.addons.enable_capi_operator, false)
    enable_ray_operator          = try(var.addons.enable_ray_operator, false)
    # orchestration
    enable_crossplane = try(var.addons.enable_crossplane, false)
    enable_vcluster   = try(var.addons.enable_vcluster, false)
    # gitops promoter
    enable_kargo           = try(var.addons.enable_kargo, false)
    enable_gitops_promoter = try(var.addons.enable_gitops_promoter, true)
    # messaging
    enable_strimzi = try(var.addons.enable_strimzi, false)
    enable_nats    = try(var.addons.enable_nats, false)
    # platform engineering
    enable_karpor = try(var.addons.enable_karpor, false)
    enable_kro    = try(var.addons.enable_kro, false)
    enable_dapr   = try(var.addons.enable_dapr, false)
    # networking
    enable_ingress_nginx = try(var.addons.enable_ingress_nginx, false)
    enable_traefik       = try(var.addons.enable_traefik, false)
    enable_cilium        = try(var.addons.enable_cilium, false)
    enable_calico        = try(var.addons.enable_calico, false)
    enable_metallb       = try(var.addons.enable_metallb, false)
    enable_ngrok         = try(var.addons.enable_ngrok, false)
    enable_istio         = try(var.addons.enable_istio, false)
    # monitoring
    enable_grafana_operator           = try(var.addons.enable_grafana_operator, false)
    enable_metrics_server             = try(var.addons.enable_metrics_server, false)
    enable_cortex                     = try(var.addons.enable_cortex, false)
    enable_prometheus_adapter         = try(var.addons.enable_prometheus_adapter, false)
    enable_logging_operator           = try(var.addons.enable_logging_operator, false)
    enable_kube_prometheus_stack      = try(var.addons.enable_kube_prometheus_stack, false)
    enable_victoria_metrics_k8s_stack = try(var.addons.enable_victoria_metrics_k8s_stack, false)
    enable_victoria_logs              = try(var.addons.enable_victoria_logs, false)
    enable_pyroscope                  = try(var.addons.enable_pyroscope, false)
    enable_alloy                      = try(var.addons.enable_alloy, false)
    enable_vector                     = try(var.addons.enable_vector, false)
    enable_promtail                   = try(var.addons.enable_promtail, false)
    enable_fluentbit                  = try(var.addons.enable_fluentbit, false)
    enable_fluentd                    = try(var.addons.enable_fluentd, false)
    enable_zipkin                     = try(var.addons.enable_zipkin, false)
    enable_loki                       = try(var.addons.enable_loki, false)
    enable_pyrra                      = try(var.addons.enable_pyrra, false)
    enable_tempo                      = try(var.addons.enable_tempo, false)
    enable_thanos                     = try(var.addons.enable_thanos, false)
    enable_opentelemetry_operator     = try(var.addons.enable_opentelemetry_operator, false)
    enable_kiali                      = try(var.addons.enable_kiali, false)
    enable_jaeger                     = try(var.addons.enable_jaeger, false)
    # security
    enable_cert_manager     = try(var.addons.enable_cert_manager, false)
    enable_trivy            = try(var.addons.enable_trivy, false)
    enable_sealed_secrets   = try(var.addons.enable_sealed_secrets, false)
    enable_external_secrets = try(var.addons.enable_external_secrets, false)
    enable_vault            = try(var.addons.enable_vault, false)
    enable_kubescape        = try(var.addons.enable_kubescape, false)
    # cost
    enable_opencost = try(var.addons.enable_opencost, false)
    enable_kepler   = try(var.addons.enable_kepler, false)
    # compliance
    enable_kyverno                 = try(var.addons.enable_kyverno, false)
    enable_kyverno_policies        = try(var.addons.enable_kyverno_policies, false)
    enable_kyverno_policy_reporter = try(var.addons.enable_kyverno_policy_reporter, false)
    enable_polaris                 = try(var.addons.enable_polaris, false)
    enable_connaisseur             = try(var.addons.enable_connaisseur, false)
    # chaos engineering
    enable_litmus     = try(var.addons.enable_litmus, false)
    enable_chaos_mesh = try(var.addons.enable_chaos_mesh, false)
    # storage
    enable_cloudnative_pg = try(var.addons.enable_cloudnative_pg, false)
    enable_minio          = try(var.addons.enable_minio, false)
    # dora metrics
    enable_devlake = try(var.addons.enable_devlake, false)
    # misc
    enable_reloader  = try(var.addons.enable_reloader, false)
    enable_reflector = try(var.addons.enable_reflector, false)
    enable_headlamp  = try(var.addons.enable_headlamp, false)
    # portal
    enable_backstage = try(var.addons.enable_backstage, false)
    # machine learning
    enable_mlflow  = try(var.addons.enable_mlflow, false)
    enable_kuberay = try(var.addons.enable_kuberay, false)
    enable_seldon  = try(var.addons.enable_seldon, false)
    enable_litellm = try(var.addons.enable_litellm, false)
    enable_milvus  = try(var.addons.enable_milvus, false)
    enable_ollama  = try(var.addons.enable_ollama, false)
  }
  addons = merge(
    local.oss_addons,
    { kubernetes_version = local.cluster_version },
    { k8s_cluster_name = local.cluster_name },
    { k8s_domain_name = local.domain_name },
  )

  addons_metadata = merge(
    {
      addons_repo_url      = local.gitops_addons_url
      addons_repo_basepath = local.gitops_addons_basepath
      addons_repo_path     = local.gitops_addons_path
      addons_repo_revision = local.gitops_addons_revision
    },
    {
      resources_repo_url      = local.gitops_resources_url
      resources_repo_basepath = local.gitops_resources_basepath
      resources_repo_revision = local.gitops_resources_revision
    },
    {
      workload_repo_url      = local.gitops_workload_url
      workload_repo_basepath = local.gitops_workload_basepath
      workload_repo_path     = local.gitops_workload_path
      workload_repo_revision = local.gitops_workload_revision
    },
    {
      cluster_repo_url      = local.gitops_cluster_url
      cluster_repo_basepath = local.gitops_cluster_basepath
      cluster_repo_path     = local.gitops_cluster_path
      cluster_repo_revision = local.gitops_cluster_revision
    },
    {
      backstage_github_token = var.backstage_github_token
    },
  )

  argocd_helm_values = <<-EOT
    dex:
      enabled: false
    notifications:
      enabled: false
    EOT

  argocd_apps = {
    addons    = file("${path.module}/bootstrap/argocd/addons.yaml")
    workloads = file("${path.module}/bootstrap/argocd/workloads.yaml")
    clusters  = file("${path.module}/bootstrap/argocd/clusters.yaml")
  }

  tags = {
    Blueprint  = local.name
    GithubRepo = "github.com/thatmlopsguy/k8s-homelab"
  }
}
