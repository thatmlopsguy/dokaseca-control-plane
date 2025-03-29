cluster_name           = "main"
domain_name            = "k8s-home.lab"
kubernetes_version     = "1.31.2"
enable_gitops_bridge   = false
enable_fluxcd          = true
fluxcd_namespace       = "flux-system"
fluxcd_chart_version   = "2.15.0"
gitops_addons_org      = "https://github.com/thatmlopsguy"
gitops_addons_repo     = "k8s-homelab"
gitops_addons_basepath = "gitops/argocd"
gitops_addons_path     = "addons"
gitops_addons_revision = "dev"
argocd_chart_version   = "7.8.4"
addons = {
  # gitops bridge create enable_argocd variable
  enable_argo_cd               = true
  enable_argo_cd_image_updater = true
  enable_gitops_promoter       = false
  enable_argo_rollouts         = true
  enable_argo_workflows        = false
  enable_argo_events           = false
  enable_kargo                 = true
  enable_keptn                 = false
  enable_keda                  = false
  enable_dapr                  = false
  enable_kro                   = false
  enable_capi_operator         = false
  enable_ray_operator          = false
  enable_vcluster              = false
  enable_open_feature          = false
  # platform engineering
  enable_karpor = false
  # monitoring
  enable_metrics_server             = false
  enable_kube_prometheus_stack      = false
  enable_victoria_metrics_k8s_stack = false
  enable_victoria_logs              = false
  enable_grafana_operator           = false
  enable_cortex                     = false
  enable_thanos                     = false
  enable_tempo                      = false
  enable_zipkin                     = false
  enable_jaeger                     = false
  enable_opentelemetry_operator     = false
  enable_kiali                      = false
  # security
  enable_cert_manager     = true
  enable_external_secrets = false
  enable_trivy            = false
  enable_kubescape        = false
  # networking
  enable_metallb       = true
  enable_cilium        = false
  enable_calico        = false
  enable_ingress_nginx = true
  enable_ngrok         = false
  enable_istio         = false
  # compliance
  enable_kyverno                 = false
  enable_kyverno_policies        = false
  enable_kyverno_policy_reporter = false
  enable_polaris                 = false
  enable_connaisseur             = false
  # logging
  enable_promtail         = false
  enable_fluentbit        = false
  enable_fluentd          = false
  enable_alloy            = false
  enable_vector           = false
  enable_logging_operator = false
  # cost
  enable_opencost = false
  # disaster recovery
  enable_velero = false
  # storage
  enable_minio          = false
  enable_cloudnative_pg = false
  enable_atlas_operator = false
  # messaging
  enable_strimzi = false
  enable_nats    = false
  # dora
  enable_devlake = false
  # chaos engineering
  enable_litmus     = false
  enable_chaos_mesh = false
  # utils
  enable_reloader  = false
  enable_reflector = false
  enable_headlamp  = false
  # portal
  enable_backstage = false # requires enable_cloudnative_pg
}
gitops_resources_org      = "https://github.com/thatmlopsguy"
gitops_resources_repo     = "k8s-homelab"
gitops_resources_basepath = "charts"
gitops_resources_revision = "dev"
gitops_workload_org       = "https://github.com/thatmlopsguy"
gitops_workload_repo      = "k8s-homelab"
gitops_workload_basepath  = "gitops/argocd"
gitops_workload_path      = "workloads"
gitops_workload_revision  = "dev"
gitops_cluster_org        = "https://github.com/thatmlopsguy"
gitops_cluster_repo       = "k8s-homelab"
gitops_cluster_basepath   = "gitops/argocd"
gitops_cluster_path       = "clusters"
gitops_cluster_revision   = "dev"
