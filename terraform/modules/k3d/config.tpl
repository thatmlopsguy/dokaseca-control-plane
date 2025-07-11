apiVersion: k3d.io/v1alpha5
kind: Simple
metadata:
  name: ${cluster_type}
servers: ${servers}
agents: ${agents}
image: rancher/k3s:${k3s_version}
