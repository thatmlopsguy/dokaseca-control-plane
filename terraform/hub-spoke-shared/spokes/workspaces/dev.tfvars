environment          = "dev"
cluster_type         = "spoke"
domain_name          = "k8s-home.lab"
cloud_provider       = "local"
kubernetes_version   = "1.33.1"
enable_gitops_bridge = true
gitops_org           = "https://github.com/thatmlopsguy"
# Teams
teams = {
  team-a = "true"
  team-b = "true"
  team-c = "false"
}
# Addons
gitops_addons_repo     = "dokaseca-addons"
gitops_addons_basepath = "argocd"
gitops_addons_path     = "appsets"
gitops_addons_revision = "main"
argocd_chart_version   = "8.1.3"
argocd_files_config = {
  load_addons    = false
  load_workloads = true
}
addons = {
  # dashboard
  enable_headlamp       = false
  enable_helm_dashboard = false
  enable_komoplane      = false # requires enable_crossplane
  # continuous delivery
  # gitops bridge create enable_argocd variable
  enable_argo_cd        = false
  enable_argo_rollouts  = false
  enable_argo_workflows = false
  enable_argo_events    = false
  enable_keptn          = false
  # developer experience
  enable_keda = false
  enable_dapr = false
  # feature flags
  enable_open_feature = false
  # orchestration
  enable_capi_operator = false # requires enable_cert_manager
  enable_crossplane    = false
  enable_vcluster      = false
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
  enable_kubevip       = false
  enable_metallb       = true
  enable_cilium        = false
  enable_calico        = false
  enable_ingress_nginx = false
  enable_traefik       = false
  enable_ngrok         = false
  enable_istio         = false
  # compliance
  enable_kyverno                 = false
  enable_kyverno_policies        = false
  enable_kyverno_policy_reporter = false
  enable_polaris                 = false
  enable_connaisseur             = false
  # logging
  enable_fluentbit        = false
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
  # databases
  enable_cloudnative_pg      = false
  enable_atlas_operator      = false
  enable_cloudbeaver         = false
  enable_clickhouse_operator = false
  enable_mariadb_operator    = false
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
  enable_kured     = false
  enable_eraser    = false
  # portal
  enable_backstage = false # requires enable_cloudnative_pg
  # machine learning
  enable_ray_operator = false
  enable_mlflow       = false
  enable_kuberay      = false
  enable_seldon       = false
  enable_litellm      = false
  enable_milvus       = false
  enable_ollama       = false
  # azure
  enable_azure_service_operator = false # requires enable_cert_manager
  # aws
  # gcp
}
# Resources
gitops_addons_extras_repo     = "helm-charts"
gitops_addons_extras_basepath = "stable"
gitops_addons_extras_revision = "main"
# Workloads
gitops_workloads_repo     = "dokaseca-workloads"
gitops_workloads_basepath = "argocd"
gitops_workloads_path     = "workloads"
gitops_workloads_revision = "main"

