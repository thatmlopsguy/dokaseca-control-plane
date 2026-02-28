# Crossplane

## Create Kind cluster

```bash
kind create cluster --name crossplane
```

## Install Crossplane via helm

```bash
helm repo add crossplane-stable https://charts.crossplane.io/stable
helm install crossplane --namespace crossplane-system crossplane-stable/crossplane
```
