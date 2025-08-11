#!/bin/bash
# This script sets up a Kubernetes Fleet environment using kind clusters.
# It creates a hub cluster and a member cluster, installs Fleet on the hub,
# and joins the member cluster to the hub.
# https://kubefleet.dev/docs/getting-started/kind/
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# The names of the kind clusters; you may use values of your own if you'd like to.
export HUB_CLUSTER=hub
export MEMBER_CLUSTER=member-1

# Create hub cluster if it doesn't exist
if ! kind get clusters | grep -q "^${HUB_CLUSTER}$"; then
    echo "Creating hub cluster: ${HUB_CLUSTER}"
    kind create cluster --name "${HUB_CLUSTER}"
else
    echo "Hub cluster ${HUB_CLUSTER} already exists, skipping creation"
fi

# Create member cluster if it doesn't exist
if ! kind get clusters | grep -q "^${MEMBER_CLUSTER}$"; then
    echo "Creating member cluster: ${MEMBER_CLUSTER}"
    kind create cluster --name "${MEMBER_CLUSTER}"
else
    echo "Member cluster ${MEMBER_CLUSTER} already exists, skipping creation"
fi

kubectl config use-context "kind-${HUB_CLUSTER}"

# Install Fleet on the hub cluster.
export REGISTRY="mcr.microsoft.com/aks/fleet"
export FLEET_VERSION
FLEET_VERSION=$(curl "https://api.github.com/repos/Azure/fleet/tags" | jq -r '.[0].name')
export HUB_AGENT_IMAGE="hub-agent"

# Install the helm chart for running Fleet agents on the hub cluster.
# helm install hub-agent "${PROJECT_ROOT}/third_party/kubefleet/charts/hub-agent/" \
#     --set image.pullPolicy=Always \
#     --set image.repository="${REGISTRY}/${HUB_AGENT_IMAGE}" \
#     --set image.tag="${FLEET_VERSION}" \
#     --set logVerbosity=2 \
#     --set namespace=fleet-system \
#     --set enableWebhook=true \
#     --set webhookClientConnectionType=service \
#     --set enableV1Alpha1APIs=false \
#     --set enableV1Beta1APIs=true

kubectl get pods -n fleet-system

# Query the API server address of the hub cluster.
export HUB_CLUSTER_ADDRESS
HUB_CLUSTER_ADDRESS="https://$(docker inspect "${HUB_CLUSTER}-control-plane" --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}'):6443"
export MEMBER_CLUSTER_CONTEXT="kind-${MEMBER_CLUSTER}"
export HUB_CLUSTER_CONTEXT="kind-${HUB_CLUSTER}"

# Run the script.
echo "HUB_CLUSTER_ADDRESS: ${HUB_CLUSTER_ADDRESS}"
echo "MEMBER_CLUSTER_CONTEXT: ${MEMBER_CLUSTER_CONTEXT}"

kubectl config use-context "${MEMBER_CLUSTER_CONTEXT}"

cd "${PROJECT_ROOT}/third_party/kubefleet"
# Run the join script to add the member cluster to the hub.
# Assuming the join script is located at /kubefleet/hack/membership/join.sh
chmod +x "${PROJECT_ROOT}/third_party/kubefleet/hack/membership/join.sh"

./hack/membership/join.sh

kubectl config use-context "${HUB_CLUSTER_CONTEXT}"
kubectl get membercluster "${MEMBER_CLUSTER}" --show-labels

# NAME       JOINED   AGE    MEMBER-AGENT-LAST-SEEN   NODE-COUNT   AVAILABLE-CPU   AVAILABLE-MEMORY   LABELS
# member-1   True     7m4s   1s                       1            12850m          15817420Ki         <none>

# Create a namespace and a configmap in the hub cluster
kubectl create namespace work
kubectl create configmap app -n work --from-literal=data=test

# Create a ClusterResourcePlacement to place resources in the 'work' namespace
# This is an example of how to use Fleet to manage resources across clusters.
# Adjust the resourceSelectors and policy as needed for your use case.
echo "Creating ClusterResourcePlacement..."
kubectl config use-context "${HUB_CLUSTER_CONTEXT}"

kubectl apply -f - <<EOF
apiVersion: placement.kubernetes-fleet.io/v1beta1
kind: ClusterResourcePlacement
metadata:
  name: crp
spec:
  resourceSelectors:
    - group: ""
      kind: Namespace
      version: v1
      name: work
  policy:
    placementType: PickAll
EOF

# Verify the ClusterResourcePlacement
echo "Verifying ClusterResourcePlacement..."
kubectl get clusterresourceplacement crp

# Switch back to the member cluster context
echo "Switching to member cluster context: ${MEMBER_CLUSTER_CONTEXT}"

kubectl config use-context "${MEMBER_CLUSTER_CONTEXT}"
kubectl get ns
kubectl get configmap -n work
