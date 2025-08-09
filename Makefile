# Project Setup
PROJECT_NAME := control-plane-dev
# Read the version from the VERSION file
RELEASE_VERSION ?= $(shell cat VERSION)
GIT_HASH ?= $(shell git log --format="%h" -n 1)

# Setting SHELL to bash allows bash commands to be executed by recipes.
# Options are set to exit when a recipe line exits non-zero or a piped command fails.
SHELL = /usr/bin/env bash -o pipefail
.SHELLFLAGS = -ec

all: help

.PHONY: help
##@ General
help: ## Show this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage: \033[36m\033[0m\n"} /^[a-zA-Z0-9_-]+:.*?##/ { printf "  \033[36m%-26s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

release: ## Show release version
	@echo $(RELEASE_VERSION)-$(GIT_HASH)

clean-infra: kind-delete-all-clusters terraform-rm-state ## Clean all infrastructure

##@ Terraform
terraform-rm-state: ## remove all terraform states
	@echo "Removing terraform state files..."
	@rm -rf terraform/terraform.tfstate.d
	@echo "Terraform state files removed."

##@ KinD
kind-create-cluster: ## Create kind cluster
	@if [ ! "$(shell kind get clusters | grep $(PROJECT_NAME))" ]; then \
		kind create cluster --name=$(PROJECT_NAME) --config distros/kind/simple.yaml --wait 180s; \
		kubectl wait pod --all -n kube-system --for condition=Ready --timeout 180s; \
	fi

kind-delete-cluster: ## Delete kind cluster
	@if [ "$(shell kind get clusters | grep $(PROJECT_NAME))" ]; then \
		kind delete cluster --name=$(PROJECT_NAME) || true; \
	fi

kind-delete-all-clusters: ## Delete all kind clusters
	@echo "Deleting all KinD clusters..."
	@kind get clusters | xargs -r -I {} kind delete cluster --name {}
	@echo "All KinD clusters deleted."

kind-export-kubeconfig: ## Export kind kubeconfig
	@kind export kubeconfig --name $(PROJECT_NAME) --internal --kubeconfig kubeconfigs/$(PROJECT_NAME)

kind-list-clusters: ## list kind clusters
	@kind get clusters

##@ K3s
k3d-create-cluster: ## Create k3d cluster
	@k3d cluster create --config=distros/k3d/simple.yml

k3d-list-clusters: ## list k3d clusters
	@k3d cluster list

autok3s-serve: ## run autok3s serve
	@autok3s serve &

##@ Cluster API
cluster-api-status: ## get status of clusters from cluster api
	@kubectl get kubeadmcontrolplane

cluster-team-a: ## Create manifest spoke-dev
	clusterctl generate cluster spoke-dev \
		--flavor development \
		--infrastructure docker \
		--kubernetes-version v1.31.0 \
		--control-plane-machine-count=1 \
		--worker-machine-count=1 > c1-clusterapi.yaml

##@ Ingress
ingress-nginx: ## Deploy ingress-nginx
	@kubectl apply -f https://kind.sigs.k8s.io/examples/ingress/deploy-ingress-nginx.yaml

ingress-lb-ip: ## Get ingress-nginx load balancer ip
	@kubectl get svc ingress-nginx-controller -n ingress-nginx -o jsonpath='{.status.loadBalancer.ingress[0].ip}'; echo

##@ FluxCD
flux-check: ## Check prerequisites
	@flux check --pre

##@ Kubectl
kubectl-current-context: ## Get current kubectl context
	@kubectl config current-context

kubectl-get-contexts: ## List kubectl contexts
	@kubectl config get-contexts -o name

##@ Argo
argo-cd-install: ## Install argocd
	@kubectl create namespace argocd || true
	@kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

argo-cd-kustomize-install: ## Install argocd with kustomize
	@kustomize build --enable-helm kustomize/argo-cd | kubectl apply -f -
	@rm -rf kustomize/argo-cd/charts

argo-cd-login: ## Login to argocd
	@argocd login --insecure localhost:8088 --username admin --password $(shell kubectl get secret -n argocd argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)

argo-cd-cluster-list: ## List argocd clusters
	@argocd cluster list

argo-cd-ui: ## Access argocd ui
	@kubectl port-forward svc/argo-cd-argocd-server -n argocd 8088:443

argo-cd-password: ## Get argocd password
	@kubectl get secret -n argocd argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo

argo-rollout-ui: ## Access argocd rollout dashboard
	@kubectl port-forward svc/argo-rollouts-dashboard -n argo-rollouts 3100:3100

##@ Observability (metrics, traces, logs)
grafana-vm-ui: ## Access grafana ui
	@kubectl port-forward svc/victoria-metrics-k8s-stack-grafana -n monitoring 3000:80

grafana-vm-password: ## Get grafana password
	@kubectl get secret -n monitoring victoria-metrics-k8s-stack-grafana -o jsonpath="{.data.admin-password}" | base64 --decode; echo

grafana-ui: ## Access grafana ui
	@kubectl port-forward svc/kube-prometheus-stack-grafana -n monitoring 3000:80

grafana-password: ## Get grafana password (default: prom-operator)
	@kubectl get secret -n monitoring kube-prometheus-stack-grafana -o jsonpath="{.data.admin-password}" | base64 --decode; echo

prometheus-ui: ## Access prometheus ui
	@kubectl port-forward svc/kube-prometheus-stack-prometheus -n monitoring 9090:9090

vm-ui: ## Access victoria metrics ui
	@kubectl port-forward svc/vmsingle-victoria-metrics-k8s-stack -n monitoring 8429:8429

vm-logs-ui: ## Access victoria metrics logs ui
	@kubectl port-forward svc/victoria-logs-single-server -n monitoring 9428:9428

alertmanager-vm-ui: ## Access alertmanager ui
	@kubectl port-forward svc/vmalertmanager-victoria-metrics-k8s-stack -n monitoring 9093:9093

vmalert-ui: ## Access vmalert ui
	@kubectl port-forward svc/vmalert-victoria-metrics-k8s-stack -n monitoring 8081:8080

zipkin-ui: ## Access zipkin ui
	@kubectl port-forward svc/zipkin -n zipkin 9411:9411

jaeger-ui: ## Access jaeger ui
	@kubectl port-forward svc/jaeger-query -n monitoring 16686:80

kiali-ui: ## Access kiali ui
	@kubectl port-forward -n istio-system svc/kiali 20001:20001

restart-monitoring-stack: ## Restart monitoring stack
	@kubectl rollout restart deploy,sts -n monitoring

##@ Security
kubescape-scan: ## scan kubernetes
	@kubescape scan

##@ Compliance
kyverno-policy-reporter-ui: ## Access kyverno policy reporter ui
	@kubectl port-forward service/policy-reporter-ui 8082:8080 -n policy-reporter

polaris-ui: ## Access polaris dashboard
	@kubectl port-forward -n polaris svc/polaris-dashboard 9080:80

cosign-gen-keys: ## generate cosign key pair
	@cosign generate-key-pair

##@ Cost
opencost-ui: ## Access opencost ui
	@kubectl port-forward -n opencost service/opencost 9092:9090

goldilocks-ui: ## Access goldilocks ui
	@kubectl port-forward -n goldilocks svc/goldilocks-dashboard 8080:80

##@ Chaos Engineering
litmus-ui: ## Access Litmus ui
	@echo "default credentials Username: admin Password: litmus"
	@kubectl port-forward -n litmus svc/litmus-frontend-service 9091:9091

chaos-mesh-ui: ## Access chaos mesh ui
	@kubectl port-forward -n chaos-mesh svc/chaos-dashboard 2333:2333

##@ SRE
keptn-password: ## Get keptn password
	@kubectl get secret -n keptn-system bridge-credentials -o jsonpath={.data.BASIC_AUTH_PASSWORD} | base64 -d

keptn-ui: ## Access keptn ui
	@kubectl port-forward -n keptn-system svc/lifecycle-webhook-service 8081:443

##@ Platform Engineering
karpor-ui: ## Access karpor ui
	@kubectl -n karpor port-forward service/karpor-server 7443:7443

headlamp-ui: ## Access headlamp ui
	@kubectl port-forward -n kube-system service/headlamp 8087:80

headlamp-token: ## Get headlamp token
	@kubectl create token headlamp -n kube-system

k8s-dashboard-ui: ## Get k8s-dashboard ui
	@kubectl port-forward -n kube-system svc/kubernetes-dashboard-web 8001:8000

k8s-dashboard-token: ## Get k8s-dashboard token
	@kubectl create token admin-user -n kube-system

backstage-ui: ## Access backstage ui
	@kubectl port-forward svc/backstage -n backstage 7007:7007

kargo-ui: ## Access kargo ui (password: oFUvUWUmelWqEIZ6ppHQrkEfFaPgvvJx)
	@kubectl port-forward svc/kargo-api -n kargo 8081:80

kargo-secret: ## Create kargo secret (requires apache2-utils)
	@echo "Generating credentials..."
	@pass=$$(openssl rand -base64 48 | tr -d "=+/" | head -c 32); \
	echo "Password: $$pass"; \
	echo "Password Hash: $$(htpasswd -bnBC 10 "" $$pass | tr -d ':')"; \
	echo "Signing Key: $$(openssl rand -base64 48 | tr -d "=+/" | head -c 32)"

vclusters: ## list of vclusters
	@vcluster list

komoplane-ui: ## Access komoplane-ui (crossplane dashboard)
	@kubectl port-forward svc/komoplane -n komoplane 8090:8090

cyclops-ui: ## Access cyclops-ui
	@kubectl port-forward svc/cyclops-ui 3001:3000 -n cyclops

dapr-ui: ## Access dapr dashboard
	@kubectl port-forward svc/dapr-dashboard  8001:8080 -n dapr-system

##@ Documentation
.PHONY: docs-install docs-serve docs-build
docs-install: ## Install the requirements for starting the local web server for serving docs
	@python -m venv .venv && \
	. .venv/bin/activate && \
	pip install -U pip && \
	pip install -r requirements/docs.txt

docs-serve: docs-install ## Start a local web server for serving documentation
	@mkdocs serve || echo "Error running mkserve. Have you run make install?"

docs-build: docs-install ## Build the documentation site
	@mkdocs build
