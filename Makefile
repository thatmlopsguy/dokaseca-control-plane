all: help

.PHONY: help
##@ General
help: ## Show this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage: \033[36m\033[0m\n"} /^[a-zA-Z0-9_-]+:.*?##/ { printf "  \033[36m%-25s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

##@ Terraform
terraform-init: ## Initialize terraform modules
	@cd terraform && terraform init

terraform-apply: ## Create infra
	@cd terraform && terraform apply -auto-approve

terraform-destroy: ## Destroy infra
	@cd terraform && terraform destroy --auto-approve

##@ Argo
argo-cd-ui: ## Access argocd ui
	@kubectl port-forward svc/argo-cd-argocd-server -n argocd 8088:443

argo-cd-password: ## Get argocd password
	@kubectl get secret -n argocd argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
