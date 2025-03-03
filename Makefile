# Project Setup
PROJECT_NAME := k8s-homelab

all: help

.PHONY: help
##@ General
help: ## Show this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage: \033[36m\033[0m\n"} /^[a-zA-Z0-9_-]+:.*?##/ { printf "  \033[36m%-26s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

##@ Terraform
terraform-init: ## Initialize terraform modules
	@cd terraform && terraform init

terraform-apply: terraform-init ## Create infra
	@cd terraform && terraform apply -auto-approve

terraform-destroy: ## Destroy infra
	@cd terraform && terraform destroy --auto-approve

##@ KinD
kind-create-cluster: ## Create kind cluster
	@if [ ! "$(shell kind get clusters | grep $(PROJECT_NAME))" ]; then \
		kind create cluster --name=$(PROJECT_NAME) --config kind/simple.yaml --wait 180s; \
		kubectl wait pod --all -n kube-system --for condition=Ready --timeout 180s; \
	fi

kind-delete-cluster: ## Delete kind cluster
	@if [ "$(shell kind get clusters | grep $(PROJECT_NAME))" ]; then \
		kind delete cluster --name=$(PROJECT_NAME) || true; \
	fi

##@ Cluster API
cluster-spoke-dev: ## Create manifest spoke-dev
	clusterctl init --infrastructure docker
	clusterctl generate cluster spoke-dev \
		--flavor development \
		--infrastructure docker \
		--kubernetes-version v1.31.0 \
		--control-plane-machine-count=1 \
		--worker-machine-count=1 > c1-clusterapi.yaml

##@ Ingress
ingress-nginx: ## Deploy ingress-nginx
	kubectl apply -f https://kind.sigs.k8s.io/examples/ingress/deploy-ingress-nginx.yaml

##@ Argo
argo-cd-ui: ## Access argocd ui
	@kubectl port-forward svc/argo-cd-argocd-server -n argocd 8088:443

argo-cd-password: ## Get argocd password
	@kubectl get secret -n argocd argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo

##@ Observability (metrics, traces, logs)
grafana-vm-ui: ## Access grafana ui
	@kubectl port-forward svc/victoria-metrics-k8s-stack-grafana -n monitoring 3000:80

grafana-vm-password: ## Get grafana password
	@kubectl get secret -n monitoring victoria-metrics-k8s-stack-grafana -o jsonpath="{.data.admin-password}" | base64 --decode; echo

vm-ui: ## Access victoria metrics ui
	@kubectl port-forward svc/vmsingle-victoria-metrics-k8s-stack -n monitoring 8429:8429

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

##@Compliance
kyverno-policy-reporter-ui: ## Access kyverno policy reporter ui
	@kubectl port-forward service/policy-reporter-ui 8082:8080 -n policy-reporter

polaris-ui: ## Access polaris dashboard
	@kubectl port-forward -n polaris svc/polaris-dashboard 9080:80

##@ Cost
opencost-ui: ## Access opencost ui
	@kubectl port-forward -n opencost service/opencost 9092:9090

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

##@ Documentation
.PHONY: docs-install docs-serve docs-build
docs-install: ## Install the requirements for starting the local web server for serving docs
	@python -m venv .venv && \
	. .venv/bin/activate && \
	pip install -U pip && \
	pip install -r requirements/docs.txt

docs-serve: docs-install ## Start a local web server for serving documentation
	@mkdocs serve || echo "Error running mkserve. Have you run make install?"
