environment                 = "dev"
cluster_type                = "spoke"
domain_name                 = "k8s-home.lab"
cloud_provider              = "local"
kubernetes_distro           = "kind" # options: kind, vind
kubernetes_version          = "1.35.1"
kubernetes_cni              = "default" # options: default, calico, cilium, flannel, istio
kubernetes_cni_version      = "1.18.5"
enable_vault                = true
enable_gateway_api          = true
gateway_api_release_version = "v1.4.1"
gitops_controller           = "argocd" # options: argocd, fluxcd
gitops_org                  = "https://github.com/thatmlopsguy"
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
argocd_chart_version   = "9.1.5"
argocd_files_config = {
  load_addons    = true
  load_workloads = false
}
addons = {
  # artifacts
  enable_harbor      = false
  enable_nexus       = false
  enable_chartmuseum = false
  enable_artifactory = false
  # multi tenancy
  enable_capsule = false
  # dashboard
  enable_headlamp       = false
  enable_helm_dashboard = false
  enable_komoplane      = false # requires enable_crossplane
  # ci/cd
  enable_tekton = false
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
  # platform engineering
  enable_karpor = false
  enable_kro    = false
  # gitops promoter
  enable_argo_cd_image_updater = false
  enable_kargo                 = false
  enable_gitops_promoter       = false
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
  enable_external_secrets = true
  enable_trivy            = false
  enable_kubescape        = false
  # networking
  enable_gateway_api   = false # managed by terraform
  enable_ingress_nginx = false # TODO deprecated, use gateway api instead
  enable_traefik       = false
  enable_skupper       = false
  ## bare metal load-balancer for Kubernetes
  enable_kubevip = false
  enable_metallb = true
  ## doesn't work with gitops yet, needs to be installed with terraform provider helm_release for now,
  ## TODO find a way to make it work with gitops
  enable_flannel = false
  enable_cilium  = false
  enable_calico  = false
  enable_istio   = false
  enable_linkerd = false
  enable_ngrok   = false
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
  enable_opencost   = false
  enable_kepler     = false
  enable_kube_green = false
  # disaster recovery
  enable_velero = false
  # storage
  enable_minio     = false
  enable_rook_ceph = false
  enable_longhorn  = false
  # databases
  enable_cloudnative_pg      = false
  enable_atlas_operator      = false
  enable_cloudbeaver         = false
  enable_clickhouse_operator = false
  enable_mariadb_operator    = false
  enable_documentdb_operator = false
  enable_weaviate            = false
  enable_milvus              = false
  # messaging
  enable_strimzi = false
  enable_nats    = false
  # dora
  enable_devlake = false
  # chaos engineering
  enable_litmus     = false
  enable_chaos_mesh = false
  # utils
  enable_reloader                 = false
  enable_reflector                = false
  enable_kured                    = false
  enable_eraser                   = false
  enable_k8s_image_swapper        = false
  enable_spegel                   = false
  enable_harbor_container_webhook = false
  # portal
  enable_backstage = false # requires enable_cloudnative_pg
  # machine learning
  enable_mlflow           = false
  enable_kuberay          = false
  enable_seldon           = false
  enable_litellm          = false
  enable_litellm_operator = false
  enable_langfuse         = false
  enable_ollama           = false
  enable_vllm_stack       = false
  enable_llm_d            = false
  # schedulers
  enable_kueue    = false
  enable_yunikorn = false
  enable_volcano  = false
  # azure
  enable_azure_service_operator = false # requires enable_cert_manager
  # aws
  # gcp
  # enterprise
  enable_kubecost             = false
  enable_vcluster             = false
  enable_nvidia_gpu_operator  = false
  enable_nvidia_device_plugin = false
  enable_nvidia_kai_scheduler = false
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
