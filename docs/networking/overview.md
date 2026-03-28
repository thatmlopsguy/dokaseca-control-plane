# Networking

This document provides an overview of the networking components used in our Kubernetes homelab setup, including Container Network Interfaces (CNIs), load balancers, ingress controllers, API gateways, and service meshes.

## Container Network Interfaces (CNI)

CNIs provide networking for pod-to-pod communication within the cluster.

### Cilium

[Cilium](https://cilium.io/) is our primary CNI, leveraging eBPF for high-performance, secure networking with additional observability features.

#### Installation

For KinD clusters:

```sh
# Deploy Cilium on KinD
cilium install --version 1.14.3 \
  --set kubeProxyReplacement=strict \
  --set k8sServiceHost=control-plane-dev-control-plane \
  --set k8sServicePort=6443
```

#### Validation

```sh
# Check Cilium status
cilium status

# Run connectivity test
cilium connectivity test
```

#### Multi-cluster

For multi-cluster networking with Cilium:

```sh
# Enable cluster mesh
cilium clustermesh enable --service-type NodePort
```

## Load Balancer

### MetalLB

[MetalLB](https://metallb.universe.tf/) provides a network load balancer implementation for bare-metal Kubernetes clusters.

#### Installing MetalLB

```sh
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.14.3/config/manifests/metallb-native.yaml
```

#### Configuration

To complete the layer2 configuration, you need to provide MetalLB with a range of IP addresses it controls, which should be on the docker kind network. To find the IP address range, run:

```sh
docker network inspect -f '{{.IPAM.Config}}' kind
```

Then apply a configuration like this:

```yaml
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: first-pool
  namespace: metallb-system
spec:
  addresses:
  - 172.18.255.200-172.18.255.250
---
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
  name: l2-advert
  namespace: metallb-system
```

### Kube-vip

[Kube-vip](https://kube-vip.io/) provides high availability for Kubernetes control plane and services.

#### Installing Kube-vip

```sh
# Deploy as DaemonSet for control plane HA
kubectl apply -f https://raw.githubusercontent.com/kube-vip/kube-vip-manifests/main/control-plane/daemonset.yaml
```

## References

- [Cilium Documentation](https://docs.cilium.io/)
- [MetalLB Configuration](https://metallb.universe.tf/configuration/)
- [Kube-vip: Deploying KIND](https://kube-vip.io/docs/usage/kind/)
- [NGINX Ingress Controller](https://kubernetes.github.io/ingress-nginx/)
- [Istio Documentation](https://istio.io/latest/docs/)
- [chmodshubham/cilium](https://github.com/chmodshubham/cilium)
- [Kubernetes Multicluster with Kind and Cilium](https://piotrminkowski.com/2021/10/25/kubernetes-multicluster-with-kind-and-cilium/)
- [Kubernetes Multicluster Load Balancing with Skupper](https://piotrminkowski.com/2023/08/04/kubernetes-multicluster-load-balancing-with-skupper/)
- [Simplifying multi-clusters in Kubernetes](https://www.cncf.io/blog/2021/04/12/simplifying-multi-clusters-in-kubernetes/)
