#!/bin/bash
#
# https://github.com/crossplane-contrib/provider-argocd

ARGOCD_ADMIN_SECRET=$(kubectl view-secret argocd-initial-admin-secret -n argocd -q)

ARGOCD_ADMIN_TOKEN=$(curl -s -X POST -k -H "Content-Type: application/json" --data '{"username":"admin","password":"'"${ARGOCD_ADMIN_SECRET}"'"}' https://localhost:8088/api/v1/session | jq -r .token)

ARGOCD_PROVIDER_USER="provider-argocd"
ARGOCD_TOKEN=$(curl -s -X POST -k -H "Authorization: Bearer ${ARGOCD_ADMIN_TOKEN}" -H "Content-Type: application/json" https://localhost:8088/api/v1/account/"${ARGOCD_PROVIDER_USER}"/token | jq -r .token)

echo "${ARGOCD_ADMIN_TOKEN}"

kubectl create secret generic argocd-credentials -n crossplane-system --from-literal=authToken="${ARGOCD_TOKEN}"

# Create a secret for the ArgoCD provider user token
# https://docs.opsmx.com/opsmx-intelligent-software-delivery-isd-platform-argo/additional-resources/create-api-token-in-argo-cd
# kubectl patch configmap/argocd-cm --type merge -p '{"data":{"accounts.admin":"apiKey"}}' -n argocd
# argocd account generate-token
