environment                 = "dev"
region                      = "local"
cluster_type                = "stable"
cluster_name                = "standalone"
domain_name                 = "dokaseca.local"
cloud_provider              = "local"
kubernetes_distro           = "kind" # options: kind, vind
kubernetes_version          = "1.35.1"
kubernetes_cni              = "cilium" # options: default, calico, cilium, flannel, istio
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
  enable_harbor      = false # TODO
  enable_chartmuseum = false # TODO
  # multi tenancy
  enable_capsule               = false # TODO
  enable_multi_tenant_operator = false # TODO
  # rbac
  enable_oauth2_proxy          = false # TODO
  enable_authentik             = false # TODO
  enable_keycloak              = false # TODO
  enable_authelia              = false # TODO
  enable_paralus               = false # TODO
  enable_rbac_manager          = false # TODO
  enable_argo_cd_rbac_operator = false # TODO
  enable_openfga               = false # TODO
  # dashboard
  enable_headlamp           = false # Tested
  enable_helm_dashboard     = false
  enable_komoplane          = false
  enable_altinity_dashboard = false
  enable_dapr_dashboard     = false
  enable_velero_ui          = false
  enable_ocm_dashboard      = false
  enable_falcosidekick      = false
  enable_policy_reporter    = false
  enable_kiali              = false
  enable_kafbat_ui          = false
  # infrastructure
  enable_atlantis  = false
  enable_semaphore = false
  # fleet manager
  enable_kubefleet_hub_agent     = false # TODO
  enable_kubefleet_member_agent  = false # TODO
  enable_open_cluster_management = false # TODO
  enable_gardener                = false # TODO
  enable_project_sveltos         = false # TODO
  # ci/cd
  enable_tekton = false
  # continuous delivery
  # gitops bridge create enable_argocd variable
  enable_argo_cd       = false
  enable_argo_cd_agent = false # TODO
  enable_argo_rollouts = false
  enable_argo_events   = false
  # developer experience
  enable_open_feature = false # feature flags
  enable_openfunction = false
  # orchestration
  enable_capi_operator = false
  enable_crossplane    = false
  enable_koreo         = false
  # gitops promotion
  enable_argo_cd_image_updater = false
  enable_kargo                 = true
  enable_gitops_promoter       = false
  # platform engineering
  enable_karpor = false
  enable_kro    = false
  enable_dapr   = false
  enable_choreo = false
  enable_krateo = false
  # messaging
  enable_strimzi           = false
  enable_nats              = false
  enable_rabbitmq_operator = false
  # networking
  enable_metallb       = true
  enable_kubevip       = false
  enable_gateway_api   = false
  enable_envoy         = true
  enable_kgateway      = false
  enable_istio         = false
  enable_ingress_nginx = true
  enable_traefik       = false
  enable_external_dns  = false
  enable_skupper       = false
  # monitoring
  enable_signoz                     = false
  enable_uptrace                    = false
  enable_k8s_monitoring             = false
  enable_kube_prometheus_stack      = false
  enable_victoria_metrics_k8s_stack = false
  # alerts
  enable_alertmanager = false
  enable_sloth        = false
  # agents
  enable_alloy                  = false
  enable_vector                 = false
  enable_fluentbit              = false
  enable_opentelemetry_operator = false
  # metrics
  enable_prometheus_adapter = false
  enable_metrics_server     = false
  enable_thanos             = false
  enable_cortex             = false
  enable_mimir              = false
  # logs
  enable_loki             = false
  enable_victoria_logs    = false
  enable_logging_operator = false
  enable_opensearch       = false
  # dashboards
  enable_grafana          = false
  enable_grafana_operator = false
  enable_pyrra            = false
  # tracing
  enable_tempo           = false
  enable_jaeger          = false
  enable_victoria_traces = false
  # profiling
  enable_pyroscope = false
  enable_parca     = false
  # security
  enable_secrets_store_csi_driver = false
  enable_cert_manager             = true
  enable_trust_manager            = false
  enable_trivy                    = false
  enable_trivy_operator           = false
  enable_sealed_secrets           = false
  enable_external_secrets         = true
  enable_vault                    = false
  enable_openbao                  = false
  enable_kubearmor                = false
  enable_falco                    = false
  enable_tetragon                 = false
  enable_tracee                   = false
  enable_dependency_tracker       = false # TODO
  # cost
  enable_opencost   = false
  enable_kepler     = false
  enable_kube_green = false
  enable_goldilocks = false
  enable_kruise     = false # TODO
  # compliance
  enable_kyverno                 = false # Tested
  enable_kyverno_policies        = false # Tested
  enable_kyverno_policy_reporter = false
  enable_polaris                 = false
  enable_connaisseur             = false
  enable_policy_controller       = false
  # chaos engineering
  enable_litmus     = false
  enable_chaos_mesh = false
  # storage
  enable_rustfs           = true
  enable_minio            = false
  enable_rook_ceph        = false
  enable_longhorn         = false
  enable_seaweedfs        = false
  enable_piraeus_operator = false
  # databases
  enable_cloudnative_pg      = false
  enable_atlas_operator      = false
  enable_cloudbeaver         = false
  enable_clickhouse_operator = false
  enable_mariadb_operator    = false
  enable_mongodb_operator    = false
  enable_documentdb_operator = false
  enable_weaviate            = false
  enable_milvus              = false
  # dora metrics
  enable_devlake   = false
  enable_open_dora = false
  # utilities
  enable_reloader                 = false
  enable_reflector                = false
  enable_k8s_replicator           = false
  enable_kured                    = false
  enable_eraser                   = false
  enable_k8s_image_swapper        = false # TODO see https://github.com/estahn/k8s-image-swapper
  enable_spegel                   = false
  enable_harbor_container_webhook = false
  enable_fake_gpu_operator        = false # TODO see https://github.com/run-ai/fake-gpu-operator
  enable_kuik                     = false
  enable_inspektor_gadget         = false
  enable_kor                      = false
  enable_kwok                     = false
  # scaling
  enable_keda              = false # Tested
  enable_keda_addons_http  = false
  enable_keda_kaito_scaler = false # TODO
  # portal
  enable_backstage = false # TODO
  # tests
  enable_report_portal = false # TODO
  # workload manager
  enable_temporal       = false # Tested
  enable_airflow        = false # Tested
  enable_dagster        = false # Tested
  enable_argo_workflows = false
  # schedulers
  enable_kueue    = false # Tested
  enable_yunikorn = false # Tested
  enable_volcano  = false # Tested
  # distributed computing
  enable_kuberay        = false # Tested
  enable_spark_operator = false # TODO
  enable_slurm_operator = false # TODO
  # machine learning
  enable_hami             = false # TODO see https://project-hami.io/
  enable_kaito            = false # TODO
  enable_llm_d            = false # TODO
  enable_ai_runway        = false # TODO see https://github.com/kaito-project/airunway
  enable_feast            = false # TODO
  enable_kserve           = false # TODO
  enable_mlflow           = false # Tested
  enable_seldon           = false # TODO
  enable_litellm          = false # TODO
  enable_litellm_operator = false # TODO
  enable_langfuse         = false # Tested
  enable_arize_phoenix    = false # TODO
  enable_vllm_stack       = false # Tested
  enable_kubeflow_trainer = false # Tested
  # analytics
  enable_flink_operator = false # TODO
  enable_superset       = false # TODO
  enable_trino          = false # TODO
  # disaster recovery
  enable_velero         = false # Tested
  enable_brudi_operator = false # TODO
  # incident management
  enable_oneuptime       = false # TODO
  enable_oneuptime_agent = false # TODO
  # internal platform
  enable_teams                     = false
  enable_gateway_class             = true
  enable_kro_rgds                  = false
  enable_kyverno_internal_policies = false
  # enterprise
  enable_portkey_gateway = false
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
# Extra configuration
extra_mounts = [
  {
    host_path      = "/var/run/docker.sock"
    container_path = "/var/run/docker.sock"
  },
  # https://tetragon.io/docs/getting-started/install-k8s/
  {
    host_path      = "/proc"
    container_path = "/procHost"
  },
  # https://oneuptime.com/blog/post/2026-03-31-rook-deploy-rook-ceph-kind-kubernetes-in-docker/view
  {
    host_path      = "/dev"
    container_path = "/dev"
  }
]
