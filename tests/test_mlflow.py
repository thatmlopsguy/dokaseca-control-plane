# /// script
# requires-python = ">=3.12"
# dependencies = [
#   "mlflow",
#   "boto3"
# ]
# ///


"""Test MLflow tracking server and S3 artifact storage backend.

uv run tests/test_mlflow.py

Prerequisites:
  - MLflow service port-forwarded: kubectl port-forward -n mlflow svc/mlflow 5000:80
  - MinIO reachable at MLFLOW_S3_ENDPOINT_URL (default: http://localhost:9000)

Environment variables (optional):
  MLFLOW_TRACKING_URI       (default: http://localhost:5000)
  MLFLOW_S3_ENDPOINT_URL    (default: http://localhost:9000)
  AWS_ACCESS_KEY_ID         MinIO user for the mlflow bucket (default: from MINIO_MLFLOW_USER)
  AWS_SECRET_ACCESS_KEY     MinIO password (default: from MINIO_MLFLOW_PASSWORD)
"""

import os
import tempfile
import pathlib

# Configure S3/MinIO endpoint before importing mlflow so boto3 picks it up
os.environ.setdefault("MLFLOW_S3_ENDPOINT_URL", os.environ.get("MINIO_ENDPOINT", "http://localhost:9000"))
os.environ.setdefault("AWS_ACCESS_KEY_ID", os.environ.get("MINIO_MLFLOW_USER", "mlflow"))
os.environ.setdefault("AWS_SECRET_ACCESS_KEY", os.environ.get("MINIO_MLFLOW_PASSWORD", ""))
# Disable AWS STS session tokens — MinIO uses static credentials
#os.environ.pop("AWS_SESSION_TOKEN", None)
#os.environ.pop("AWS_SECURITY_TOKEN", None)

import mlflow

TRACKING_URI = os.environ.get("MLFLOW_TRACKING_URI", "http://localhost:5000")
EXPERIMENT_NAME = "smoke-test"


def main():
    mlflow.set_tracking_uri(TRACKING_URI)
    print(f"Tracking URI : {TRACKING_URI}")

    # 1. Verify tracking server is reachable
    version = mlflow.version.VERSION
    print(f"MLflow client : {version}")

    # 2. Create / get experiment
    mlflow.set_experiment(EXPERIMENT_NAME)
    experiment = mlflow.get_experiment_by_name(EXPERIMENT_NAME)
    print(f"Experiment    : {experiment.name} (id={experiment.experiment_id})")
    print(f"Artifact loc  : {experiment.artifact_location}")

    # 3. Start a run — log params, metrics, and an artifact file
    with mlflow.start_run(run_name=f"{EXPERIMENT_NAME}-run") as run:
        run_id = run.info.run_id
        print(f"Run ID        : {run_id}")

        # Parameters
        mlflow.log_param("framework", "pytest")
        mlflow.log_param("test_type", "smoke")

        # Metrics (simulate 5 training steps)
        for step in range(5):
            mlflow.log_metric("loss", 1.0 / (step + 1), step=step)
            mlflow.log_metric("accuracy", (step + 1) * 0.2, step=step)

        # Artifact — write a small text file and log it
        with tempfile.TemporaryDirectory() as tmp:
            artifact_path = pathlib.Path(tmp) / "hello.txt"
            artifact_path.write_text("MLflow smoke-test artifact\n")
            mlflow.log_artifact(str(artifact_path))

        print("Logged params, metrics, and artifact.")

    # 4. Read back and verify
    client = mlflow.tracking.MlflowClient(TRACKING_URI)
    fetched_run = client.get_run(run_id)

    assert fetched_run.data.params["framework"] == "pytest"
    assert fetched_run.data.params["test_type"] == "smoke"
    assert float(fetched_run.data.metrics["accuracy"]) == 1.0
    print("Params/metrics verified.")

    artifacts = client.list_artifacts(run_id)
    artifact_names = [a.path for a in artifacts]
    assert "hello.txt" in artifact_names, f"Artifact not found. Got: {artifact_names}"
    print(f"Artifacts     : {artifact_names}")

if __name__ == "__main__":
    main()
