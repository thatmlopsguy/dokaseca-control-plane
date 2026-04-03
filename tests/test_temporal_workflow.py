# /// script
# requires-python = ">=3.12"
# dependencies = [
#   " temporalio"
# ]
# ///

"""Quick Temporal workflow integration test

uv run tests/test_temporal_workflow.py

Requirements:
- Install the Temporal Python SDK: `pip install temporalio` (or add to your venv).
- Ensure the Temporal frontend is reachable (default: localhost:7233).

If Temporal is running inside Kubernetes, you can port‑forward the frontend service locally:

```bash
# run from a kube-config context that can reach the Temporal namespace
kubectl -n temporal port-forward svc/temporal-frontend 7233:7233
```

This script starts a simple workflow and checks it completes with expected result.
Configure connection with env vars:
- TEMPORAL_HOST (default: localhost)
- TEMPORAL_PORT (default: 7233)
- TEMPORAL_NAMESPACE (default: default)

Run with pytest or directly: `python tests/test_temporal_workflow.py`
"""
from __future__ import annotations

import asyncio
import os

try:
    from temporalio.client import Client
    from temporalio.worker import Worker
    from temporalio import workflow
except Exception as e:
    print("Missing dependency: install temporalio (pip install temporalio)")
    raise

# Simple workflow and activity definitions used only by this test.
@workflow.defn
class HelloWorkflow:
    @workflow.run
    async def run(self, name: str) -> str:
        # trivial workflow body
        return f"Hello, {name}!"


async def run_test():
    host = os.environ.get("TEMPORAL_HOST", "localhost")
    port = os.environ.get("TEMPORAL_PORT", "7233")
    namespace = os.environ.get("TEMPORAL_NAMESPACE", "default")
    target = f"{host}:{port}"

    print(f"Connecting to Temporal at {target} namespace={namespace}")

    client = await Client.connect(f"{host}:{port}", namespace=namespace)

    # Start a short-lived worker for the test that hosts the workflow implementation.
    task_queue = "test-task-queue"

    async with Worker(client, task_queue=task_queue, workflows=[HelloWorkflow]):
        # Start the workflow
        handle = await client.start_workflow(HelloWorkflow.run, "world", id="test-hello-1", task_queue=task_queue)
        print("Started workflow; waiting for result...")
        result = await handle.result()
        print("Workflow result:", result)
        assert result == "Hello, world!", f"unexpected workflow result: {result}"


if __name__ == "__main__":
    try:
        asyncio.run(run_test())
    except Exception:
        # Make sure traceback is visible for CI
        raise
