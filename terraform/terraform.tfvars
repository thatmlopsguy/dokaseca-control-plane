cluster_name           = "control-plane"
domain_name            = "k8s-home.lab"
cloud_provider         = "local"
kubernetes_version     = "1.31.2"
enable_gitops_bridge   = true
enable_fluxcd          = false
fluxcd_namespace       = "flux-system"
fluxcd_chart_version   = "2.15.0"
gitops_addons_org      = "https://github.com/thatmlopsguy"
gitops_addons_repo     = "k8s-homelab"
gitops_addons_basepath = "gitops/argocd"
gitops_addons_path     = "addons"
gitops_addons_revision = "dev"
argocd_chart_version   = "7.8.4"
addons = {
  # identity
  enable_authentik = false
  enable_keycloak  = false
  enable_authelia  = false
  # gitops bridge create enable_argocd variable
  enable_argo_cd               = false
  enable_argo_cd_image_updater = false
  enable_argo_rollouts         = false
  enable_argo_workflows        = false
  enable_argo_events           = false
  enable_keptn                 = false
  enable_keda                  = false
  enable_dapr                  = false
  enable_capi_operator         = false
  enable_ray_operator          = false
  enable_open_feature          = false
  # orchestration
  enable_crossplane = false
  enable_vcluster   = true
  # gitops promoter
  enable_kargo           = false
  enable_gitops_promoter = false
  enable_codefresh       = false
  # platform engineering
  enable_karpor = false
  enable_kro    = false
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
  enable_kubevip       = true
  enable_metallb       = true
  enable_cilium        = false
  enable_calico        = false
  enable_ingress_nginx = false
  enable_traefik       = true
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
  # machine learning
  enable_mlflow  = false
  enable_kuberay = false
  enable_seldon  = false
  enable_litellm = false
  enable_milvus  = false
  enable_ollama  = false
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
