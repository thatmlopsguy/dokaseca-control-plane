# Workflow Orchestration

DoKa Seca integrates with workflow orchestration tools to automate complex data pipelines and machine learning workflows. This allows you to schedule, monitor, and manage your workflows efficiently.

## Components Overview

Doka Seca's workflow orchestration stack includes:

1. **Apache Airflow** - For orchestrating complex workflows
2. **Argo Workflows** - For Kubernetes-native workflow orchestration
3. **Dagster** - For data orchestrations with a focus on software engineering best practices
4. **Temporal** - For long-running, stateful workflows with strong consistency guarantees

## Apache Airflow

[Apache Airflow](https://airflow.apache.org/) is an open-source platform to programmatically author, schedule, and monitor workflows. Doka Seca integrates Airflow to manage complex data pipelines and machine learning workflows.

## Argo Workflows

[Argo Workflows](https://argoproj.github.io/argo-workflows/) is a Kubernetes-native workflow engine for orchestrating parallel jobs. Doka Seca leverages Argo Workflows to run containerized tasks on Kubernetes clusters.

## Dagster

[Dagster](https://dagster.io/) is a data orchestrator for machine learning, analytics, and ETL. Doka Seca uses Dagster to build and manage data pipelines with a focus on software engineering best practices.

## Temporal

[Temporal](https://temporal.io/) is a platform for running long-running, stateful workflows with strong consistency guarantees. Doka Seca integrates Temporal to manage complex workflows that require reliability and scalability.
