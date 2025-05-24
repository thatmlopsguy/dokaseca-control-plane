# Security

## Trivy

$ kubectl create deployment nginx --image nginx:1.16

$ kubectl get configauditreports -o wide
NAME                          SCANNER   AGE     CRITICAL   HIGH   MEDIUM   LOW
replicaset-nginx-599c4f6679   Trivy     3m16s   0          2      3        10
