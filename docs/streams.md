# Message Streaming and Event Brokers

This document provides an overview of the message streaming and event broker options supported in the DoKa Seca.
We support three major messaging systems via their respective Kubernetes operators: Strimzi (for Apache Kafka),
NATS, and RabbitMQ.

## Overview

Messaging systems play a critical role in modern distributed architectures, enabling asynchronous communication, event-driven patterns, and data streaming. DoKa Seca provides support for three complementary messaging systems, each with different strengths:

| System                 | Best For                                       | Key Features                                            | Performance Profile                    |
|------------------------|------------------------------------------------|---------------------------------------------------------|----------------------------------------|
| Apache Kafka (Strimzi) | High-throughput data streaming, event sourcing | Strong ordering, persistence, replay capability         | High throughput, higher latency        |
| NATS                   | Lightweight messaging, request/reply, pub/sub  | Simple, fast, large fan-out                             | Ultra-low latency, moderate throughput |
| RabbitMQ               | Traditional message queueing, complex routing  | Rich routing capabilities, flexible delivery guarantees | Moderate latency, good throughput      |

## Strimzi (Apache Kafka)

[Strimzi](https://strimzi.io/) provides a way to run an Apache Kafka cluster on Kubernetes using custom resources and operators.

### Installation

```bash
# Add the Strimzi Helm repository
helm repo add strimzi https://strimzi.io/charts/
helm repo update

# Install the Strimzi operator
helm install strimzi-kafka-operator strimzi/strimzi-kafka-operator \
  --namespace strimzi-system \
  --create-namespace \
  --version 0.39.0
```

### Deploying a Kafka Cluster

Create a Kafka cluster using the following Custom Resource:

```yaml
apiVersion: kafka.strimzi.io/v1beta2
kind: Kafka
metadata:
  name: my-kafka-cluster
  namespace: kafka
spec:
  kafka:
    version: 3.6.0
    replicas: 3
    listeners:
      - name: plain
        port: 9092
        type: internal
        tls: false
      - name: tls
        port: 9093
        type: internal
        tls: true
      - name: external
        port: 9094
        type: nodeport
        tls: false
    config:
      offsets.topic.replication.factor: 3
      transaction.state.log.replication.factor: 3
      transaction.state.log.min.isr: 2
      default.replication.factor: 3
      min.insync.replicas: 2
      inter.broker.protocol.version: "3.6"
    storage:
      type: jbod
      volumes:
      - id: 0
        type: persistent-claim
        size: 100Gi
        deleteClaim: false
  zookeeper:
    replicas: 3
    storage:
      type: persistent-claim
      size: 10Gi
      deleteClaim: false
  entityOperator:
    topicOperator: {}
    userOperator: {}
```

### Creating Topics

```yaml
apiVersion: kafka.strimzi.io/v1beta2
kind: KafkaTopic
metadata:
  name: my-topic
  namespace: kafka
  labels:
    strimzi.io/cluster: my-kafka-cluster
spec:
  partitions: 10
  replicas: 3
  config:
    retention.ms: 604800000
    segment.bytes: 1073741824
```

### Accessing Kafka

```bash
# Port forward the Kafka service
kubectl -n kafka port-forward svc/my-kafka-cluster-kafka-bootstrap 9092:9092

# Use kafkacat to produce messages
echo "Hello, Kafka!" | kcat -b localhost:9092 -t my-topic -P

# Consume messages
kcat -b localhost:9092 -t my-topic -C
```

## NATS

[NATS](https://nats.io/) is a simple, secure and high-performance messaging system designed for cloud native applications,
IoT messaging, and microservices architectures.

### Installing NATS Operator

```bash
# Add the NATS Helm repository
helm repo add nats https://nats-io.github.io/k8s/helm/charts/
helm repo update

# Install the NATS operator
helm install nats-operator nats/nats-operator \
  --namespace nats-system \
  --create-namespace
```

### Deploying a NATS Cluster

Create a NATS cluster with the following manifest:

```yaml
apiVersion: nats.io/v1alpha2
kind: NatsCluster
metadata:
  name: nats-cluster
  namespace: nats
spec:
  size: 3
  version: "2.10.7"
  pod:
    enableConfigReload: true
  auth:
    enableServiceAccounts: true
  jetstream:
    enabled: true
    memStorage:
      enabled: true
      size: 1Gi
    fileStorage:
      enabled: true
      storageClassName: standard
      size: 10Gi
```

### Creating Streams and Consumers

With JetStream enabled, you can create streams and consumers:

```bash
# Port forward the NATS service
kubectl -n nats port-forward svc/nats-cluster 4222:4222

# Create a stream
nats stream add my-stream \
  --subjects="orders.*" \
  --retention=limits \
  --storage=file \
  --replicas=3 \
  --max-msgs=-1 \
  --max-bytes=-1 \
  --max-age=1y \
  --max-msg-size=-1 \
  --dupe-window=2m

# Create a consumer
nats consumer add my-stream my-consumer \
  --filter="orders.created" \
  --ack=explicit \
  --pull \
  --deliver=all \
  --max-deliver=10 \
  --replay=instant
```

## RabbitMQ

[RabbitMQ](https://www.rabbitmq.com/) is a widely deployed open source message broker that implements several messaging protocols.

### Installing RabbitMQ Operator

```bash
# Add the RabbitMQ Helm repository
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

# Install the RabbitMQ Cluster Operator
kubectl apply -f "https://github.com/rabbitmq/cluster-operator/releases/latest/download/cluster-operator.yml"
```

### Deploying a RabbitMQ Cluster

Create a RabbitMQ cluster using the following manifest:

```yaml
apiVersion: rabbitmq.com/v1beta1
kind: RabbitmqCluster
metadata:
  name: rabbitmq-cluster
  namespace: rabbitmq
spec:
  replicas: 3
  resources:
    requests:
      cpu: 500m
      memory: 1Gi
    limits:
      cpu: 1
      memory: 2Gi
  rabbitmq:
    additionalConfig: |
      cluster_partition_handling = autoheal
      vm_memory_high_watermark.relative = 0.8
  persistence:
    storageClassName: standard
    storage: 10Gi
  service:
    type: ClusterIP
  terminationGracePeriodSeconds: 180
```

### Creating Vhosts, Queues, and Exchanges

After the cluster is deployed, you can create vhosts, queues, exchanges, and bindings using the RabbitMQ management UI or the CLI:

```bash
# Port forward the RabbitMQ management UI
kubectl -n rabbitmq port-forward svc/rabbitmq-cluster 15672:15672

# Get the admin credentials
RABBITMQ_USER="$(kubectl -n rabbitmq get secret rabbitmq-cluster-default-user -o jsonpath='{.data.username}' | base64 --decode)"
RABBITMQ_PASS="$(kubectl -n rabbitmq get secret rabbitmq-cluster-default-user -o jsonpath='{.data.password}' | base64 --decode)"

# Use the RabbitMQ CLI
kubectl -n rabbitmq exec rabbitmq-cluster-server-0 -- rabbitmqadmin \
  -u "$RABBITMQ_USER" -p "$RABBITMQ_PASS" \
  declare vhost name=my-vhost

# Create a queue
kubectl -n rabbitmq exec rabbitmq-cluster-server-0 -- rabbitmqadmin \
  -u "$RABBITMQ_USER" -p "$RABBITMQ_PASS" \
  declare queue name=my-queue vhost=my-vhost durable=true

# Create an exchange
kubectl -n rabbitmq exec rabbitmq-cluster-server-0 -- rabbitmqadmin \
  -u "$RABBITMQ_USER" -p "$RABBITMQ_PASS" \
  declare exchange name=my-exchange type=topic vhost=my-vhost durable=true
```

## Integration with Applications

### Application Example Using Kafka

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: kafka-consumer-app
  namespace: kafka
spec:
  replicas: 1
  selector:
    matchLabels:
      app: kafka-consumer-app
  template:
    metadata:
      labels:
        app: kafka-consumer-app
    spec:
      containers:
      - name: consumer
        image: myapp/kafka-consumer:latest
        env:
        - name: KAFKA_BOOTSTRAP_SERVERS
          value: my-kafka-cluster-kafka-bootstrap:9092
        - name: KAFKA_TOPIC
          value: my-topic
```

### Application Example Using NATS

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nats-publisher-app
  namespace: nats
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nats-publisher-app
  template:
    metadata:
      labels:
        app: nats-publisher-app
    spec:
      containers:
      - name: publisher
        image: myapp/nats-publisher:latest
        env:
        - name: NATS_URL
          value: nats://nats-cluster:4222
        - name: NATS_SUBJECT
          value: orders.created
```

### Application Example Using RabbitMQ

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: rabbitmq-worker-app
  namespace: rabbitmq
spec:
  replicas: 1
  selector:
    matchLabels:
      app: rabbitmq-worker-app
  template:
    metadata:
      labels:
        app: rabbitmq-worker-app
    spec:
      containers:
      - name: worker
        image: myapp/rabbitmq-worker:latest
        env:
        - name: RABBITMQ_HOST
          value: rabbitmq-cluster
        - name: RABBITMQ_USER
          valueFrom:
            secretKeyRef:
              name: rabbitmq-cluster-default-user
              key: username
        - name: RABBITMQ_PASS
          valueFrom:
            secretKeyRef:
              name: rabbitmq-cluster-default-user
              key: password
```

## Monitoring and Management

### Accessing Management UIs

```bash
# Access RabbitMQ management UI
kubectl -n rabbitmq port-forward svc/rabbitmq-cluster 15672:15672

# Access NATS Dashboard
kubectl -n nats port-forward svc/nats-cluster 8222:8222
```

## Best Practices

1. **Selecting the Right Messaging System**:
   - For high-throughput data pipelines: Kafka
   - For low-latency service-to-service communication: NATS
   - For complex routing needs and traditional message queueing: RabbitMQ

2. **Resource Allocation**:
   - Kafka: Allocate more disk and memory, especially for high-volume workloads
   - NATS: Optimize for network I/O, requires less memory
   - RabbitMQ: Balance between memory and CPU, monitor queue depths

3. **High Availability**:
   - Deploy at least 3 nodes for each broker in production
   - Use proper anti-affinity rules to distribute across nodes
   - Configure appropriate replication factors

4. **Monitoring**:
   - Set up Prometheus exporters for each messaging system
   - Create Grafana dashboards to monitor throughput, latency, and errors
   - Configure alerts for queue depth, consumer lag, and broker health

## References

- [Strimzi Documentation](https://strimzi.io/documentation/)
- [Apache Kafka Documentation](https://kafka.apache.org/documentation/)
- [NATS Documentation](https://docs.nats.io/)
- [NATS Kubernetes Operator](https://github.com/nats-io/nats-operator)
- [RabbitMQ Documentation](https://www.rabbitmq.com/documentation.html)
- [RabbitMQ Cluster Operator](https://www.rabbitmq.com/kubernetes/operator/operator-overview.html)
- [Event-Driven Architecture Patterns](https://developers.redhat.com/blog/2018/08/16/comparing-apache-kafka-and-red-hat-amq-streams)
