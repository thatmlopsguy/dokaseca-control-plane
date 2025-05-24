# Networking

Documentation coming soon!

## CNI

### Cilium

## Load Balancer

### Metallb

To complete the layer2 configuration, you need to provide MetalLB with a range of IP addresses it controls, which should
be on the docker kind network. To find the IP address range, run:

```sh
docker network inspect -f '{{.IPAM.Config}}' kind
```

### Kube-vip

## Ingress

## Api Gateway

## Service Mesh

## References

- [Kube-vip: Deploying KIND](https://kube-vip.io/docs/usage/kind/)
- [chmodshubham/cilium](https://github.com/chmodshubham/cilium)
- [Kubernetes Multicluster with Kind and Cilium](https://piotrminkowski.com/2021/10/25/kubernetes-multicluster-with-kind-and-cilium/)
