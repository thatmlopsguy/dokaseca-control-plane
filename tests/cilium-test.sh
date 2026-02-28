#!/bin/bash
# This script is used to test Cilium connectivity in a Kubernetes cluster.
# It assumes that the cluster is already set up and that kubectl is configured to access it
# https://docs.cilium.io/en/stable/installation/kind/#validate-the-installation

kubectl -n kube-system get pods # --watch

kubectl create ns cilium-test
kubectl apply -f https://raw.githubusercontent.com/cilium/cilium/1.19.1/examples/kubernetes/connectivity-check/connectivity-check.yaml -n cilium-test
kubectl get pods -n cilium-test
