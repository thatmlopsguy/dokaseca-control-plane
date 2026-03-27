#!/usr/bin/env bash
#

argocd_password () {
    ARGOCD_PASSWORD="${ARGOCD_PASSWORD:-admin}"
    HASH=$(argocd account bcrypt --password "${ARGOCD_PASSWORD}")
    echo "${HASH}"
}

argocd_update_password () {

    ns="${ARGOCD_NAMESPACE:-argocd}"
    initial_password=$(kubectl -n "$ns" get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
    argo_host=$(kubectl -n "$ns" get svc argocd-server -o jsonpath="{.status.loadBalancer.ingress[0].hostname}")

    # Login with retries
    for i in {1..5}; do
    if argocd login "${argo_host}" --username admin --password "${initial_password}" --insecure; then
        break
    fi
    echo "Login attempt $i failed, retrying in 5 seconds..."
    sleep 5
    done

    argocd account update-password \
        --account admin \
        --current-password "${initial_password}" \
        --new-password "${ARGOCD_PASSWORD}" || true
}
