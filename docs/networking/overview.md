# Networking

This document provides an overview of the networking components used in our Kubernetes homelab setup,
including Container Network Interfaces (CNIs), load balancers, ingress controllers, API gateways, and
service meshes.

## Container Network Interfaces (CNI)

CNIs provide networking for pod-to-pod communication within the cluster. DoKa Seca supports multiple CNIs,
with Cilium as the default for its performance and security features.

### Cilium

[Cilium](https://cilium.io/) is our primary CNI, leveraging eBPF for high-performance, secure networking
with additional observability features.

Cilium ingress validation requires more than enabling the ingress controller.
The working configuration also enables the Envoy L7 load balancer backend and NodePort support. Without those
settings, `cilium connectivity test` can fail while waiting for the generated ingress service
`cilium-ingress-same-node`.

#### Installation

For KinD clusters:

```sh
# Repo-managed Cilium settings for Kind ingress support
# See terraform/modules/cni/cilium/main.tf
helm upgrade --install cilium cilium/cilium \
  --namespace kube-system \
  --create-namespace \
  --version 1.18.5 \
  --set ingressController.enabled=true \
  --set ingressController.default=true \
  --set ingressController.loadbalancerMode=shared \
  --set ingressController.service.type=NodePort \
  --set loadBalancer.l7.backend=envoy \
  --set nodePort.enabled=true
```

The two settings below are the critical fix for the Kind connectivity failure:

- `loadBalancer.l7.backend=envoy`
- `nodePort.enabled=true`

#### Validation

```sh
# Check Cilium status
cilium status

# Run the repo wrapper
./tests/cilium-test.sh
```

If you want to verify the runtime prerequisites directly, check:

```sh
$ cilium config view | rg 'enable-node-port|enable-ingress-controller|loadbalancer-l7'
enable-ingress-controller                         true
enable-node-port                                  true
loadbalancer-l7                                   envoy
loadbalancer-l7-algorithm                         round_robin
loadbalancer-l7-ports
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

#### Enabling MetalLB

To enable MetalLB in DoKa Seca, set the following in `terraform.tfvars`:

```hcl
enable_metallb = true
```

#### Configuration

To complete the layer2 configuration, you need to provide MetalLB with a range of IP addresses it controls, which should be on
the docker kind network. To find the IP address range, run:

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

#### Enabling Kube-vip

To enable Kube-vip in DoKa Seca, set the following in `terraform.tfvars`:

```hcl
enable_kubevip = true
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
