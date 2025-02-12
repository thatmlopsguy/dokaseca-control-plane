all: help

.PHONY: help
##@ General
help: ## Show this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage: \033[36m\033[0m\n"} /^[a-zA-Z0-9_-]+:.*?##/ { printf "  \033[36m%-25s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

##@ Terraform
terraform-init: ## Initialize terraform modules
	@cd terraform && terraform init

terraform-apply: terraform-init ## Create infra
	@cd terraform && terraform apply -auto-approve

terraform-destroy: ## Destroy infra
	@cd terraform && terraform destroy --auto-approve

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
