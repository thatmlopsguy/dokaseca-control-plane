# Gateway API

The [Gateway API](https://gateway-api.sigs.k8s.io/) is a set of Kubernetes resources that provide a more flexible and extensible way to manage ingress traffic to your cluster. It allows you to define how traffic should be routed to your services based on various criteria, such as hostnames, paths, and headers.

## Installation

To enable the Gateway API in Doka Seca, you can use the following option in terraform.tfvars:

```hcl
enable_gateway_api          = true
gateway_api_release_version = "v1.4.1"
```

This will install the Gateway API CRDs and the controller in your cluster. You can verify the installation by checking for the presence of the Gateway API resources:

```sh
$ kubectl get crds | grep gateway
backendtlspolicies.gateway.networking.k8s.io  
gatewayclasses.gateway.networking.k8s.io  
gateways.gateway.networking.k8s.io  
grpcroutes.gateway.networking.k8s.io  
httproutes.gateway.networking.k8s.io  
referencegrants.gateway.networking.k8s.io  
```
