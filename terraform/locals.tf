locals {
  name        = "ex-${replace(basename(path.cwd), "_", "-")}"
  environment = var.environment
  region      = var.region

  kubernetes_name    = "${var.cluster_type}-${var.environment}"
  kubernetes_distro  = var.kubernetes_distro
  kubernetes_version = var.kubernetes_version
  kubeconfig_path    = "${dirname(path.cwd)}/kubeconfigs/${var.cluster_type}-${var.environment}"

  cloud_provider = var.cloud_provider
  domain_name    = var.domain_name

  gitops_addons_url      = "${var.gitops_org}/${var.gitops_addons_repo}"
  gitops_addons_basepath = var.gitops_addons_basepath
  gitops_addons_path     = var.gitops_addons_path
  gitops_addons_revision = var.gitops_addons_revision

  gitops_addons_extras_url      = "${var.gitops_org}/${var.gitops_addons_extras_repo}"
  gitops_addons_extras_basepath = var.gitops_addons_extras_basepath
  gitops_addons_extras_revision = var.gitops_addons_extras_revision

  gitops_workloads_url      = "${var.gitops_org}/${var.gitops_workloads_repo}"
  gitops_workloads_basepath = var.gitops_workloads_basepath
  gitops_workloads_path     = var.gitops_workloads_path
  gitops_workloads_revision = var.gitops_workloads_revision

  gitops_clusters_url      = "${var.gitops_org}/${var.gitops_clusters_repo}"
  gitops_clusters_basepath = var.gitops_clusters_basepath
  gitops_clusters_path     = var.gitops_clusters_path
  gitops_clusters_revision = var.gitops_clusters_revision

  oss_addons = {
    # dashboard
    enable_kubernetes_dashboard = try(var.addons.enable_kubernetes_dashboard, false) # TODO
    enable_headlamp             = try(var.addons.enable_headlamp, false)
    enable_helm_dashboard       = try(var.addons.enable_helm_dashboard, false)
    enable_komoplane            = try(var.addons.enable_komoplane, false)
    enable_altinity_dashboard   = try(var.addons.enable_altinity_dashboard, false)
    enable_dapr_dashboard       = try(var.addons.enable_dapr_dashboard, false)
    enable_velero_ui            = try(var.addons.enable_velero_ui, false)
    enable_ocm_dashboard        = try(var.addons.enable_ocm_dashboard, false) # TODO
    # fleet manager
    enable_gardener        = try(var.addons.enable_gardener, false)        # TODO
    enable_project_sveltos = try(var.addons.enable_project_sveltos, false) # TODO
    # observability
    # identity
    enable_oauth2_proxy = try(var.addons.enable_oauth2_proxy, false) # TODO
    enable_authentik    = try(var.addons.enable_authentik, false)    # TODO
    enable_keycloak     = try(var.addons.enable_keycloak, false)     # TODO
    enable_authelia     = try(var.addons.enable_authelia, false)     # TODO
    # delivery
    enable_argo_cd               = try(var.addons.enable_argo_cd, false)
    enable_argo_cd_rbac_operator = try(var.addons.enable_argo_cd_rbac_operator, false)
    # https://github.com/open-cluster-management-io/addon-contrib/blob/main/argocd-agent-addon/charts/argocd-agent-addon/Chart.yaml
    enable_argo_cd_agent = try(var.addons.enable_argo_cd_agent, false) # TODO
    enable_argo_rollouts = try(var.addons.enable_argo_rollouts, false)
    enable_argo_events   = try(var.addons.enable_argo_events, false)
    enable_keda          = try(var.addons.enable_keda, false)
    enable_keptn         = try(var.addons.enable_keptn, false)
    enable_open_feature  = try(var.addons.enable_open_feature, false)
    enable_openfunction  = try(var.addons.enable_openfunction, false)
    enable_sloth         = try(var.addons.enable_sloth, false)
    # fleet managers
    # https://kubefleet-dev.github.io/website/
    enable_kubefleet_hub_agent    = try(var.addons.enable_kubefleet_hub_agent, false)    # TODO
    enable_kubefleet_member_agent = try(var.addons.enable_kubefleet_member_agent, false) # TODO
    # https://open-cluster-management.io/
    enable_open_cluster_management = try(var.addons.enable_open_cluster_management, false) # TODO
    # orchestration
    enable_capi_operator = try(var.addons.enable_capi_operator, false)
    enable_crossplane    = try(var.addons.enable_crossplane, false)
    enable_koreo         = try(var.addons.enable_koreo, false) # TODO
    enable_vcluster      = try(var.addons.enable_vcluster, false)
    # gitops promoter
    enable_argo_cd_image_updater = try(var.addons.enable_argo_cd_image_updater, false)
    enable_kargo                 = try(var.addons.enable_kargo, false)
    enable_gitops_promoter       = try(var.addons.enable_gitops_promoter, false)
    # messaging
    enable_strimzi           = try(var.addons.enable_strimzi, false)
    enable_nats              = try(var.addons.enable_nats, false)
    enable_rabbitmq_operator = try(var.addons.enable_rabbitmq_operator, false)
    # platform engineering
    enable_karpor = try(var.addons.enable_karpor, false)
    enable_kro    = try(var.addons.enable_kro, false)
    enable_dapr   = try(var.addons.enable_dapr, false)
    enable_choreo = try(var.addons.enable_choreo, false) # TODO
    enable_krateo = try(var.addons.enable_krateo, false) # TODO
    # networking
    enable_skupper       = try(var.addons.enable_skupper, false)
    enable_metallb       = try(var.addons.enable_metallb, false)
    enable_kubevip       = try(var.addons.enable_kubevip, false)
    enable_ingress_nginx = try(var.addons.enable_ingress_nginx, false)
    enable_traefik       = try(var.addons.enable_traefik, false)
    enable_cilium        = try(var.addons.enable_cilium, false)
    enable_calico        = try(var.addons.enable_calico, false)
    enable_ngrok         = try(var.addons.enable_ngrok, false)
    enable_istio         = try(var.addons.enable_istio, false)
    # monitoring
    # https://github.com/grafana/k8s-monitoring-helm/tree/main/charts/k8s-monitoring
    enable_k8s_monitoring             = try(var.addons.enable_k8s_monitoring, false)
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
    enable_fluentbit                  = try(var.addons.enable_fluentbit, false)
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
    enable_kubearmor        = try(var.addons.enable_kubearmor, false)
    enable_falco            = try(var.addons.enable_falco, false)
    enable_tetragon         = try(var.addons.enable_tetragon, false)
    enable_tracee           = try(var.addons.enable_tracee, false)
    # cost
    enable_opencost   = try(var.addons.enable_opencost, false)
    enable_kepler     = try(var.addons.enable_kepler, false)
    enable_kube_green = try(var.addons.enable_kube_green, false)
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
    enable_openebs = try(var.addons.enable_openebs, false)
    enable_minio   = try(var.addons.enable_minio, false)
    # databases
    enable_cloudnative_pg      = try(var.addons.enable_cloudnative_pg, false)
    enable_clickhouse_operator = try(var.addons.enable_clickhouse_operator, false) # TODO
    enable_cloudbeaver         = try(var.addons.enable_cloudbeaver, false)         # TODO
    # dora metrics
    enable_devlake = try(var.addons.enable_devlake, false)
    # utilities
    enable_reloader  = try(var.addons.enable_reloader, false)
    enable_reflector = try(var.addons.enable_reflector, false)
    enable_kured     = try(var.addons.enable_kured, false)
    # portal
    enable_backstage = try(var.addons.enable_backstage, false)
    # workload manager
    enable_temporal       = try(var.addons.enable_temporal, false) # TODO
    enable_airflow        = try(var.addons.enable_airflow, false)  # TODO
    enable_flyte          = try(var.addons.enable_flyte, false)    # TODO
    enable_argo_workflows = try(var.addons.enable_argo_workflows, false)
    # machine learning
    enable_feast        = try(var.addons.enable_feast, false)        # TODO
    enable_kserve       = try(var.addons.enable_kserve, false)       # TODO
    enable_kubeflow     = try(var.addons.enable_kubeflow, false)     # TODO
    enable_ray_operator = try(var.addons.enable_ray_operator, false) # TODO
    enable_mlflow       = try(var.addons.enable_mlflow, false)       # TODO
    enable_kuberay      = try(var.addons.enable_kuberay, false)      # TODO
    enable_seldon       = try(var.addons.enable_seldon, false)       # TODO
    enable_litellm      = try(var.addons.enable_litellm, false)      # TODO
    enable_weaviate     = try(var.addons.enable_weaviate, false)     # TODO
    enable_milvus       = try(var.addons.enable_milvus, false)       # TODO
    enable_ollama       = try(var.addons.enable_ollama, false)       # TODO
    enable_langfuse     = try(var.addons.enable_langfuse, false)     # TODO
    enable_kgateway     = try(var.addons.enable_kgateway, false)     # TODO
  }

  # Enterprise
  enterprise_addons = {
    enable_codefresh = try(var.addons.enable_codefresh, false)
    enable_kubescape = try(var.addons.enable_kubescape, false)
  }

  # Azure
  azure_addons = {
    enable_azure_service_operator = try(var.addons.enable_azure_service_operator, false)
    enable_azure_external_secrets = try(var.addons.enable_azure_external_secrets, false)
  }

  # AWS
  aws_addons = {
    enable_aws_karpenter        = try(var.addons.enable_aws_karpenter, false)
    enable_aws_external_secrets = try(var.addons.enable_aws_external_secrets, false)
  }

  # GCP
  gcp_addons = {
    enable_gcp_keda             = try(var.addons.enable_gcp_keda, false)
    enable_gcp_external_secrets = try(var.addons.enable_gcp_external_secrets, false)
  }

  # Platform
  platform_addons = {
    enable_teams = try(var.addons.enable_teams, false)
  }

  addons = merge(
    local.oss_addons,
    local.enterprise_addons,
    local.azure_addons,
    local.aws_addons,
    local.gcp_addons,
    local.platform_addons,
    { k8s_version = local.kubernetes_version },
    { k8s_cluster_name = local.kubernetes_name },
    { domain_name = local.domain_name },
    { cloud_provider = local.cloud_provider }
  )

  addons_metadata = merge(
    {
      addons_repo_url      = local.gitops_addons_url
      addons_repo_basepath = local.gitops_addons_basepath
      addons_repo_path     = local.gitops_addons_path
      addons_repo_revision = local.gitops_addons_revision
    },
    {
      addons_extras_repo_url      = local.gitops_addons_extras_url
      addons_extras_repo_basepath = local.gitops_addons_extras_basepath
      addons_extras_repo_revision = local.gitops_addons_extras_revision
    },
    {
      workloads_repo_url      = local.gitops_workloads_url
      workloads_repo_basepath = local.gitops_workloads_basepath
      workloads_repo_path     = local.gitops_workloads_path
      workloads_repo_revision = local.gitops_workloads_revision
    },
    {
      clusters_repo_url      = local.gitops_clusters_url
      clusters_repo_basepath = local.gitops_clusters_basepath
      clusters_repo_path     = local.gitops_clusters_path
      clusters_repo_revision = local.gitops_clusters_revision
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
    global:
      addPrometheusAnnotations: true
    controller:
      logFormat: json
      metrics:
        enabled: true
    EOT

  argocd_apps = {
    addons    = var.argocd_files_config.load_addons ? file("${path.module}/bootstrap/argocd/addons.yaml") : ""
    workloads = var.argocd_files_config.load_workloads ? file("${path.module}/bootstrap/argocd/workloads.yaml") : ""
    clusters  = var.argocd_files_config.load_clusters ? file("${path.module}/bootstrap/argocd/clusters.yaml") : ""
  }

  tags = {
    Blueprint  = local.name
    GithubRepo = "github.com/thatmlopsguy/dokaseca-control-plane"
  }
}
