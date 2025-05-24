environment          = "dev"
cluster_name         = "control-plane"
domain_name          = "k8s-home.lab"
cloud_provider       = "local"
kubernetes_distro    = "kind"
kubernetes_version   = "1.31.2"
enable_gitops_bridge = true
enable_fluxcd        = false
fluxcd_namespace     = "flux-system"
fluxcd_chart_version = "2.15.0"
gitops_org           = "https://github.com/thatmlopsguy"
# Addons
gitops_addons_repo     = "dokaseca-addons"
gitops_addons_basepath = "argocd"
gitops_addons_path     = "appsets"
gitops_addons_revision = "main"
argocd_chart_version   = "7.8.26"
argocd_files_config = {
  load_addons    = true
  load_workloads = false
  load_clusters  = false
}
addons = {
  # dashboard
  enable_kubernetes_dashboard = false
  enable_headlamp             = false
  enable_helm_dashboard       = false
  enable_komoplane            = false # requires enable_crossplane
  enable_altinity_dashboard   = false
  # identity
  enable_authentik    = false
  enable_keycloak     = false
  enable_authelia     = false
  enable_oauth2_proxy = false
  # continuos delivery
  # gitops bridge create enable_argocd variable
  enable_argo_cd               = false
  enable_argo_cd_image_updater = false
  enable_argo_rollouts         = false
  enable_argo_workflows        = false
  enable_argo_events           = false
  enable_keptn                 = false
  # developer experience
  enable_keda = false
  enable_dapr = false
  # feature flags
  enable_open_feature = false
  # orchestration
  enable_capi_operator = true # requires enable_cert_manager
  enable_crossplane    = false
  enable_vcluster      = false
  enable_koreo         = false
  # gitops promoter
  enable_kargo           = false
  enable_gitops_promoter = true
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
  enable_kiali                      = false # requires enable_istio
  # security
  enable_cert_manager     = true
  enable_external_secrets = false
  enable_trivy            = false
  enable_tracee           = false
  enable_falco            = false
  enable_kubearmor        = false
  enable_tetragon         = false
  # networking
  enable_skupper       = false
  enable_kubevip       = false
  enable_metallb       = true
  enable_cilium        = false
  enable_calico        = false
  enable_ingress_nginx = true
  enable_traefik       = false
  enable_ngrok         = false
  enable_istio         = false
  # compliance
  enable_kyverno                 = false
  enable_kyverno_policies        = false
  enable_kyverno_policy_reporter = false
  enable_polaris                 = false
  enable_connaisseur             = false
  # collector agent
  enable_fluentbit        = false
  enable_alloy            = false
  enable_vector           = false
  enable_logging_operator = false
  # cost
  enable_opencost   = false
  enable_kepler     = false
  enable_kube_green = false # requires enable_cert_manager
  # disaster recovery
  enable_velero = false
  # storage
  enable_openebs        = true
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
  enable_kured     = false
  # portal
  enable_backstage = false # requires enable_cloudnative_pg
  # machine learning
  enable_ray_operator = false
  enable_mlflow       = false
  enable_kuberay      = false
  enable_seldon       = false
  enable_litellm      = false
  enable_langfuse     = false
  enable_milvus       = false
  enable_ollama       = false
  # enterprise
  enable_codefresh = false
  enable_kubescape = false
  # azure
  enable_azure_service_operator = false # requires enable_cert_manager
  # aws
  enable_aws_karpenter = false
  # gcp
  enable_gcp_keda             = false
  enable_gcp_external_secrets = false
}
# Resources
gitops_resources_repo     = "helm-charts"
gitops_resources_basepath = "stable"
gitops_resources_revision = "main"
# Workloads
gitops_workload_repo     = "k8s-homelab"
gitops_workload_basepath = "gitops/argocd"
gitops_workload_path     = "workloads"
gitops_workload_revision = "dev"
# Clusters
gitops_cluster_repo     = "k8s-homelab"
gitops_cluster_basepath = "gitops/argocd"
gitops_cluster_path     = "clusters"
gitops_cluster_revision = "dev"
