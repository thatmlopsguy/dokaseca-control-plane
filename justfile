# Project Setup
PROJECT_NAME := "control-plane-dev"

# Read the version from the VERSION file
RELEASE_VERSION := `cat VERSION`
GIT_HASH := `git log --format="%h" -n 1`

# Default recipe (no arguments)
default:
    @just --list

# Show release version
release:
    @echo {{RELEASE_VERSION}}-{{GIT_HASH}}

# Clean all infrastructure
clean-infra: kind-delete-all-clusters terraform-rm-state

# ===== Terraform =====

# Remove all terraform states
terraform-rm-state:
    @echo "Removing terraform state files..."
    rm -rf terraform/terraform.tfstate.d
    @echo "Terraform state files removed."

# ===== KinD =====

# Create kind cluster
kind-create-cluster:
    #!/usr/bin/env bash
    if [ ! "$(kind get clusters | grep {{PROJECT_NAME}})" ]; then
        kind create cluster --name={{PROJECT_NAME}} --config distros/kind/simple.yaml --wait 180s
        kubectl wait pod --all -n kube-system --for condition=Ready --timeout 180s
    fi

# Delete kind cluster
kind-delete-cluster:
    #!/usr/bin/env bash
    if [ "$(kind get clusters | grep {{PROJECT_NAME}})" ]; then
        kind delete cluster --name={{PROJECT_NAME}} || true
    fi

# Delete all kind clusters
kind-delete-all-clusters:
    @echo "Deleting all KinD clusters..."
    kind get clusters | xargs -r -I {} kind delete cluster --name {}
    @echo "All KinD clusters deleted."

# Export kind kubeconfig
kind-export-kubeconfig:
    kind export kubeconfig --name {{PROJECT_NAME}} --internal --kubeconfig kubeconfigs/{{PROJECT_NAME}}

# List kind clusters
kind-list-clusters:
    kind get clusters

# ===== K3s =====

# Create k3d cluster
k3d-create-cluster:
    k3d cluster create --config=distros/k3d/simple.yml

# List k3d clusters
k3d-list-clusters:
    k3d cluster list

# Run autok3s serve
autok3s-serve:
    autok3s serve &

# ===== Cluster API =====

# Get status of clusters from cluster api
cluster-api-status:
    kubectl get kubeadmcontrolplane

# Create manifest spoke-dev
cluster-team-a:
    clusterctl generate cluster spoke-dev \
        --flavor development \
        --infrastructure docker \
        --kubernetes-version v1.31.0 \
        --control-plane-machine-count=1 \
        --worker-machine-count=1 > c1-clusterapi.yaml

# ===== Ingress =====

# Deploy ingress-nginx
ingress-nginx:
    kubectl apply -f https://kind.sigs.k8s.io/examples/ingress/deploy-ingress-nginx.yaml

# Get ingress-nginx load balancer ip
ingress-lb-ip:
    kubectl get svc ingress-nginx-controller -n ingress-nginx -o jsonpath='{.status.loadBalancer.ingress[0].ip}'; echo

# ===== FluxCD =====

# Check prerequisites
flux-check:
    flux check --pre

# ===== Kubectl =====

# Get current kubectl context
kubectl-current-context:
    kubectl config current-context

# List kubectl contexts
kubectl-get-contexts:
    kubectl config get-contexts -o name

# ===== Argo =====

# Install argocd with kustomize
argo-cd-kustomize-install:
    kustomize build --enable-helm kustomize/argo-cd | kubectl apply -f -
    rm -rf kustomize/argo-cd/charts

# Login to argocd
argo-cd-login:
    argocd login --insecure localhost:8088 --username admin --password $(kubectl get secret -n argocd argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)

# List argocd clusters
argo-cd-cluster-list:
    argocd cluster list

# Access argocd ui
argo-cd-ui:
    kubectl port-forward svc/argo-cd-argocd-server -n argocd 8088:443

# Get argocd password
argo-cd-password:
    kubectl get secret -n argocd argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo

# Access argocd rollout dashboard
argo-rollout-ui:
    kubectl port-forward svc/argo-rollouts-dashboard -n argo-rollouts 3100:3100

# ===== Observability (metrics, traces, logs) =====

# Access grafana ui (victoria metrics)
grafana-vm-ui:
    kubectl port-forward svc/victoria-metrics-k8s-stack-grafana -n monitoring 3000:80

# Get grafana password (victoria metrics)
grafana-vm-password:
    kubectl get secret -n monitoring victoria-metrics-k8s-stack-grafana -o jsonpath="{.data.admin-password}" | base64 --decode; echo

# Access grafana ui
grafana-ui:
    kubectl port-forward svc/kube-prometheus-stack-grafana -n monitoring 3000:80

# Get grafana password (default: prom-operator)
grafana-password:
    kubectl get secret -n monitoring kube-prometheus-stack-grafana -o jsonpath="{.data.admin-password}" | base64 --decode; echo

# Access prometheus ui
prometheus-ui:
    kubectl port-forward svc/kube-prometheus-stack-prometheus -n monitoring 9090:9090

# Access victoria metrics ui
vm-ui:
    kubectl port-forward svc/vmsingle-victoria-metrics-k8s-stack -n monitoring 8429:8429

# Access victoria metrics logs ui
vm-logs-ui:
    kubectl port-forward svc/victoria-logs-single-server -n monitoring 9428:9428

# Access alertmanager ui
alertmanager-vm-ui:
    kubectl port-forward svc/vmalertmanager-victoria-metrics-k8s-stack -n monitoring 9093:9093

# Access vmalert ui
vmalert-ui:
    kubectl port-forward svc/vmalert-victoria-metrics-k8s-stack -n monitoring 8081:8080

# Access zipkin ui
zipkin-ui:
    kubectl port-forward svc/zipkin -n zipkin 9411:9411

# Access jaeger ui
jaeger-ui:
    kubectl port-forward svc/jaeger-query -n monitoring 16686:80

# Access kiali ui
kiali-ui:
    kubectl port-forward -n istio-system svc/kiali 20001:20001

# Restart monitoring stack
restart-monitoring-stack:
    kubectl rollout restart deploy,sts -n monitoring

# ===== Security =====

# Scan kubernetes
kubescape-scan:
    kubescape scan

# ===== Compliance =====

# Access kyverno policy reporter ui
kyverno-policy-reporter-ui:
    kubectl port-forward service/policy-reporter-ui 8082:8080 -n policy-reporter

# Access polaris dashboard
polaris-ui:
    kubectl port-forward -n polaris svc/polaris-dashboard 9080:80

# Generate cosign key pair
cosign-gen-keys:
    cosign generate-key-pair

# ===== Cost =====

# Access opencost ui
opencost-ui:
    kubectl port-forward -n opencost service/opencost 9092:9090

# Access goldilocks ui
goldilocks-ui:
    kubectl port-forward -n goldilocks svc/goldilocks-dashboard 8080:80

# ===== Chaos Engineering =====

# Access Litmus ui
litmus-ui:
    @echo "default credentials Username: admin Password: litmus"
    kubectl port-forward -n litmus svc/litmus-frontend-service 9091:9091

# Access chaos mesh ui
chaos-mesh-ui:
    kubectl port-forward -n chaos-mesh svc/chaos-dashboard 2333:2333

# ===== SRE =====

# Get keptn password
keptn-password:
    kubectl get secret -n keptn-system bridge-credentials -o jsonpath={.data.BASIC_AUTH_PASSWORD} | base64 -d

# Access keptn ui
keptn-ui:
    kubectl port-forward -n keptn-system svc/lifecycle-webhook-service 8081:443

# ===== Platform Engineering =====

# Access karpor ui
karpor-ui:
    kubectl -n karpor port-forward service/karpor-server 7443:7443

# Access headlamp ui
headlamp-ui:
    kubectl port-forward -n kube-system service/headlamp 8087:80

# Get headlamp token
headlamp-token:
    kubectl create token headlamp -n kube-system

# Get k8s-dashboard ui
k8s-dashboard-ui:
    kubectl port-forward -n kube-system svc/kubernetes-dashboard-web 8001:8000

# Get k8s-dashboard token
k8s-dashboard-token:
    kubectl create token admin-user -n kube-system

# Access backstage ui
backstage-ui:
    kubectl port-forward svc/backstage -n backstage 7007:7007

# Access kargo ui (password: oFUvUWUmelWqEIZ6ppHQrkEfFaPgvvJx)
kargo-ui:
    kubectl port-forward svc/kargo-api -n kargo 8081:80

# Create kargo secret (requires apache2-utils)
kargo-secret:
    #!/usr/bin/env bash
    echo "Generating credentials..."
    pass=$(openssl rand -base64 48 | tr -d "=+/" | head -c 32)
    echo "Password: $pass"
    echo "Password Hash: $(htpasswd -bnBC 10 "" $pass | tr -d ':')"
    echo "Signing Key: $(openssl rand -base64 48 | tr -d "=+/" | head -c 32)"

# List of vclusters
vclusters:
    vcluster list

# Access komoplane-ui (crossplane dashboard)
komoplane-ui:
    kubectl port-forward svc/komoplane -n komoplane 8090:8090

# Access cyclops-ui
cyclops-ui:
    kubectl port-forward svc/cyclops-ui 3001:3000 -n cyclops

# Access dapr dashboard
dapr-ui:
    kubectl port-forward svc/dapr-dashboard  8001:8080 -n dapr-system

# ===== Documentation =====

# Install the requirements for starting the local web server for serving docs
docs-install:
    python -m venv .venv && \
    . .venv/bin/activate && \
    pip install -U pip && \
    pip install -r requirements/docs.txt

# Start a local web server for serving documentation
docs-serve: docs-install
    mkdocs serve || echo "Error running mkserve. Have you run just docs-install?"

# Build the documentation site
docs-build: docs-install
    mkdocs build

# ===== Docker Compose =====

# Start all services with docker compose
docker-start:
    docker compose up -d

# Stop all services
docker-stop:
    docker compose down

# View logs of all services
docker-logs:
    docker compose logs -f

# Show status of services
docker-status:
    docker compose ps
