#!/bin/bash
# This script is used to test Cilium connectivity in a Kubernetes cluster.
# It assumes that the cluster is already set up and that kubectl is configured to access it
# https://docs.cilium.io/en/stable/installation/kind/#validate-the-installation

set -euo pipefail

# Optional selector(s) passed to `cilium connectivity test --test`.
# Default excludes a noisy log-only check that is often flaky on local Kind.
# Set CILIUM_TEST_SELECTOR="" to run the full strict suite.
CILIUM_TEST_SELECTOR="${CILIUM_TEST_SELECTOR:-!check-log-errors}"

kubectl -n kube-system get pods # --watch

# kubectl create ns cilium-test || true
# kubectl apply -f https://raw.githubusercontent.com/cilium/cilium/1.19.1/examples/kubernetes/connectivity-check/connectivity-check.yaml -n cilium-test
# sleep 5
# kubectl get pods -n cilium-test

# https://docs.cilium.io/en/stable/gettingstarted/k8s-install-default/
cilium status --wait

if [[ -n "${CILIUM_TEST_SELECTOR}" ]]; then
	cilium connectivity test --test "${CILIUM_TEST_SELECTOR}"
else
	cilium connectivity test
fi
