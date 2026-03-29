environment                 = "dev"
cluster_type                = "spoke"
domain_name                 = "k8s-home.lab"
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
  enable_nexus       = false # TODO
  enable_chartmuseum = false # TODO
  enable_artifactory = false # TODO
  # multi tenancy
  enable_capsule = false # TODO
  # rbac
  enable_paralus               = false # TODO
  enable_rbac_manager          = false # TODO
  enable_argo_cd_rbac_operator = false # TODO
  # dashboard
  enable_headlamp           = false # Tested
  enable_helm_dashboard     = false
  enable_komoplane          = false # requires enable_crossplane
  enable_altinity_dashboard = false # TODO
  enable_dapr_dashboard     = false # TODO
  enable_velero_ui          = false # TODO
  enable_ocm_dashboard      = false # TODO
  # fleet manager
  enable_kubefleet_hub_agent     = false # TODO
  enable_kubefleet_member_agent  = false # TODO
  enable_open_cluster_management = false # TODO
  enable_gardener                = false # TODO
  enable_project_sveltos         = false # TODO
  # identity
  enable_oauth2_proxy = false # TODO
  enable_authentik    = false # TODO
  enable_keycloak     = false # TODO
  enable_authelia     = false # TODO
  # ci/cd
  enable_tekton = false
  # continuous delivery
  # gitops bridge create enable_argocd variable
  enable_argo_cd       = false
  enable_argo_cd_agent = false # TODO
  enable_argo_rollouts = false
  enable_argo_events   = false
  # developer experience
  enable_keda         = false # tested
  enable_open_feature = false # feature flags
  enable_openfunction = false
  enable_sloth        = false
  # orchestration
  enable_capi_operator = false # requires enable_cert_manager
  enable_crossplane    = false
  enable_koreo         = false
  # gitops promotion
  enable_argo_cd_image_updater = false
  enable_kargo                 = false
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
  enable_gateway_api   = false
  enable_ingress_nginx = true
  enable_traefik       = false
  enable_skupper       = false
  ## bare metal load-balancer for Kubernetes
  enable_metallb      = true
  enable_kubevip      = false
  enable_external_dns = false
  # monitoring
  enable_signoz                     = false
  enable_k8s_monitoring             = false
  enable_kube_prometheus_stack      = false
  enable_victoria_metrics_k8s_stack = true
  enable_kiali                      = false
  # agents
  enable_alloy                  = false
  enable_vector                 = false
  enable_fluentbit              = false
  enable_opentelemetry_operator = false
  # metrics
  enable_prometheus_adapter = false
  enable_thanos             = false
  enable_metrics_server     = false
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
  enable_zipkin          = false
  enable_victoria_traces = false
  # profiling
  enable_pyroscope = false
  enable_parca     = false
  # security
  enable_cert_manager     = true
  enable_trust_manager    = false
  enable_trivy            = false
  enable_sealed_secrets   = false
  enable_external_secrets = false
  enable_kubearmor        = false
  enable_falco            = false
  enable_tetragon         = false
  enable_tracee           = false
  # cost
  enable_opencost   = false
  enable_kepler     = false
  enable_kube_green = false
  enable_goldilocks = false
  # compliance
  enable_kyverno                 = false
  enable_kyverno_policies        = false
  enable_kyverno_policy_reporter = false
  enable_polaris                 = false
  enable_connaisseur             = false
  enable_policy_controller       = false
  # chaos engineering
  enable_litmus     = false
  enable_chaos_mesh = false
  # storage
  enable_minio     = false
  enable_rook_ceph = false
  enable_longhorn  = false
  enable_seaweedfs = false
  # databases
  enable_cloudnative_pg      = false
  enable_atlas_operator      = false
  enable_cloudbeaver         = false
  enable_clickhouse_operator = false
  enable_mariadb_operator    = false
  enable_documentdb_operator = false
  enable_weaviate            = false
  enable_milvus              = false
  # dora metrics
  enable_devlake = false
  # utils
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
  # portal
  enable_backstage = false
  # tests
  enable_report_portal = false # TODO
  # workload manager
  enable_temporal       = false # TODO
  enable_airflow        = false # TODO
  enable_dagster        = false # TODO
  enable_prefect        = false # TODO
  enable_flyte          = false # TODO
  enable_argo_workflows = false # TODO
  # schedulers
  enable_kueue    = false
  enable_yunikorn = false
  enable_volcano  = false
  # distributed computing
  enable_kuberay        = false # TODO
  enable_spark_operator = false # TODO
  enable_slurm_operator = false # TODO
  # machine learning
  enable_kaito            = false # TODO
  enable_ai_runway        = false # TODO see https://github.com/kaito-project/airunway
  enable_feast            = false # TODO
  enable_kserve           = false # TODO
  enable_mlflow           = false # Tested
  enable_seldon           = false # TODO
  enable_litellm          = false # TODO
  enable_litellm_operator = false # TODO
  enable_ollama           = false # TODO
  enable_langfuse         = false # TODO
  enable_kgateway         = false # TODO
  enable_vllm_stack       = false # TODO
  enable_kubeflow_trainer = false # TODO see https://www.kubeflow.org/docs/components/trainer/operator-guides/installation/
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
