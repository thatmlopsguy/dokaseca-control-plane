# Distributed Computing

Doka Seca supports distributed workload operators including Ray, Spark, and Slurm, enabling scalable training, batch processing, and HPC job scheduling on Kubernetes.

## Ray Operator

[Ray](https://ray.io/) is an open-source unified framework for scaling AI and Python applications.
Doka Seca leverages the [Ray Operator for Kubernetes](https://docs.ray.io/en/latest/cluster/kubernetes/index.html) to manage distributed training workloads.

### Ray Capabilities

- **Distributed Training**: Scale machine learning workloads across multiple nodes
- **Resource Management**: Efficiently allocate CPU, GPU, and memory resources
- **Fault Tolerance**: Automatically recover from node failures
- **Dynamic Scaling**: Scale resources up or down based on workload demands

## Spark Operator

[Apache Spark](https://spark.apache.org/) provides a fast and general-purpose cluster-computing system for big data processing. Doka Seca integrates the [Spark Operator for Kubernetes](https://github.com/GoogleCloudPlatform/spark-on-k8s-operator) to run Spark applications natively on Kubernetes.

### Spark Capabilities

- **Batch & Streaming**: Run large-scale batch jobs and streaming pipelines
- **Resource Isolation**: Run Spark executors with Kubernetes-native resource requests/limits
- **Job Submission**: Declarative SparkApplication manifests for repeatable runs
- **Autoscaling**: Integrate with cluster autoscalers to scale worker pods

## Slurm Operator

[Slurm](https://slurm.schedmd.com/) is a popular job scheduler for HPC environments. Doka Seca supports the [Slurm Operator for Kubernetes](https://github.com/kubernetes-sigs/slurm-operator) to schedule and manage Slurm jobs backed by Kubernetes resources for hybrid HPC workloads.

### Slurm Capabilities

- **HPC Job Scheduling**: Submit and manage batch HPC jobs with familiar Slurm semantics
- **Resource Reservation**: Support node allocation and resource partitioning
- **Backfill & Prioritization**: Integrate Slurm scheduling policies for job placement
- **Hybrid Workloads**: Run HPC jobs alongside cloud-native workloads on Kubernetes
