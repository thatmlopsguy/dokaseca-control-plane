# /// script
# requires-python = ">=3.12"
# dependencies = [
#   "requests"
# ]
# ///

"""Test Airflow API reachability and DAG execution.

uv run tests/test_airflow.py

Prerequisites:
  - Airflow API service port-forwarded:
      kubectl port-forward -n airflow svc/airflow-api-server 8084:8080
  - Airflow credentials valid (default: admin/admin)

Environment variables (optional):
  AIRFLOW_BASE_URL      (default: http://localhost:8084)
    AIRFLOW_API_BASE      (default: auto-detect: /api/v1 or /api/v2)
  AIRFLOW_USERNAME      (default: admin)
  AIRFLOW_PASSWORD      (default: admin)
    AIRFLOW_BEARER_TOKEN  (default: empty; auto-fetch from /auth/token when possible)
  AIRFLOW_TEST_DAG_ID   (default: first unpaused DAG returned by API)
  AIRFLOW_WAIT_SECONDS  (default: 180)
  AIRFLOW_POLL_SECONDS  (default: 5)
"""

import os
import time
import uuid
from datetime import datetime, timezone
from typing import Any

import requests

AIRFLOW_BASE_URL = os.environ.get("AIRFLOW_BASE_URL", "http://localhost:8084").rstrip("/")
AIRFLOW_API_BASE = os.environ.get("AIRFLOW_API_BASE", "").strip()
AIRFLOW_USERNAME = os.environ.get("AIRFLOW_USERNAME", "admin")
AIRFLOW_PASSWORD = os.environ.get("AIRFLOW_PASSWORD", "admin")
AIRFLOW_BEARER_TOKEN = os.environ.get("AIRFLOW_BEARER_TOKEN", "").strip()
AIRFLOW_TEST_DAG_ID = os.environ.get("AIRFLOW_TEST_DAG_ID")
AIRFLOW_WAIT_SECONDS = int(os.environ.get("AIRFLOW_WAIT_SECONDS", "180"))
AIRFLOW_POLL_SECONDS = int(os.environ.get("AIRFLOW_POLL_SECONDS", "5"))


def _request(session: requests.Session, method: str, path: str, **kwargs: Any) -> requests.Response:
    response = session.request(method, f"{AIRFLOW_BASE_URL}{path}", timeout=30, **kwargs)
    if not response.ok:
        body = response.text.strip()
        raise RuntimeError(
            f"HTTP {response.status_code} {method} {AIRFLOW_BASE_URL}{path} failed. "
            f"Response: {body}"
        )
    return response


def _check_health(session: requests.Session) -> dict[str, Any]:
    # Health endpoint paths vary by Airflow version/configuration.
    for path in ("/api/v1/health", "/api/v2/monitor/health", "/health"):
        response = session.request("GET", f"{AIRFLOW_BASE_URL}{path}", timeout=30)
        if response.ok:
            return response.json()
    # Do not fail the smoke test purely on health endpoint shape; DAG API probes are authoritative.
    return {}


def _normalize_api_base(base: str) -> str:
    if not base:
        return ""
    if not base.startswith("/"):
        return f"/{base}"
    return base.rstrip("/")


def _detect_api_base(session: requests.Session) -> str:
    candidates = []
    normalized = _normalize_api_base(AIRFLOW_API_BASE)
    if normalized:
        candidates.append(normalized)
    candidates.extend(["/api/v1", "/api/v2"])

    for base in candidates:
        response = session.request("GET", f"{AIRFLOW_BASE_URL}{base}/dags?limit=1", timeout=30)
        if response.ok:
            payload = response.json()
            if isinstance(payload, dict) and "dags" in payload:
                return base

    checked = ", ".join(f"{AIRFLOW_BASE_URL}{base}/dags?limit=1" for base in candidates)
    raise RuntimeError(f"Could not detect a working Airflow API base. Checked: {checked}")


def _configure_auth(session: requests.Session) -> str:
    if AIRFLOW_BEARER_TOKEN:
        session.headers["Authorization"] = f"Bearer {AIRFLOW_BEARER_TOKEN}"
        session.auth = None
        return "bearer(env)"

    # Keep basic auth as a fallback for older Airflow deployments.
    session.auth = (AIRFLOW_USERNAME, AIRFLOW_PASSWORD)

    # Airflow 3 commonly requires a token from /auth/token.
    token_resp = session.post(
        f"{AIRFLOW_BASE_URL}/auth/token",
        json={"username": AIRFLOW_USERNAME, "password": AIRFLOW_PASSWORD},
        timeout=30,
    )
    if token_resp.ok:
        token = token_resp.json().get("access_token")
        if token:
            session.headers["Authorization"] = f"Bearer {token}"
            session.auth = None
            return "bearer(login)"

    return "basic"


def _select_dag_id(dags: list[dict[str, Any]]) -> str:
    if AIRFLOW_TEST_DAG_ID:
        return AIRFLOW_TEST_DAG_ID

    for dag in dags:
        # Prefer runnable DAGs if no explicit DAG id is provided.
        if not dag.get("is_paused", True):
            return str(dag["dag_id"])

    raise RuntimeError(
        "No unpaused DAG found. Set AIRFLOW_TEST_DAG_ID or unpause a DAG in Airflow UI/API."
    )


def main() -> None:
    print(f"Airflow URL   : {AIRFLOW_BASE_URL}")
    print(f"Username      : {AIRFLOW_USERNAME}")

    session = requests.Session()
    auth_mode = _configure_auth(session)
    print(f"Auth mode     : {auth_mode}")

    # 1. Verify API is reachable.
    health = _check_health(session)
    if health:
        print(f"Health        : {health}")
    else:
        print("Health        : not available (continuing with DAG API probe)")

    api_base = _detect_api_base(session)
    print(f"API Base      : {api_base}")

    # 2. Select a DAG to test.
    if AIRFLOW_TEST_DAG_ID:
        dag_id = AIRFLOW_TEST_DAG_ID
    else:
        dags_payload = _request(session, "GET", f"{api_base}/dags?limit=100").json()
        dags = dags_payload.get("dags", [])
        if not dags:
            raise RuntimeError(
                "No DAGs found in Airflow. Add/unpause at least one DAG, "
                "or set AIRFLOW_TEST_DAG_ID to a known DAG id."
            )
        dag_id = _select_dag_id(dags)

    # Ensure the selected DAG exists and read its paused state.
    dag_resp = _request(session, "GET", f"{api_base}/dags/{dag_id}").json()
    original_paused = bool(dag_resp.get("is_paused", True))
    print(f"DAG ID        : {dag_id}")
    print(f"Initially paused: {original_paused}")

    # Auto-unpause if needed, and ensure we restore later.
    if original_paused:
        print("Unpausing DAG for smoke test...")
        _request(session, "PATCH", f"{api_base}/dags/{dag_id}", json={"is_paused": False})

    # Run+poll in try/finally so we restore paused state afterward.
    dag_run_id = f"smoke-{int(time.time())}-{uuid.uuid4().hex[:8]}"
    trigger_payload = {
        "dag_run_id": dag_run_id,
        "logical_date": datetime.now(timezone.utc).isoformat(),
        "note": "k8s-homelab airflow smoke test",
        "conf": {"source": "smoke-test"},
    }

    try:
        _request(session, "POST", f"{api_base}/dags/{dag_id}/dagRuns", json=trigger_payload)
        print(f"DAG Run ID    : {dag_run_id}")

        # 4. Poll run state until terminal state or timeout.
        deadline = time.time() + AIRFLOW_WAIT_SECONDS
        while time.time() < deadline:
            run_resp = _request(session, "GET", f"{api_base}/dags/{dag_id}/dagRuns/{dag_run_id}").json()
            state = str(run_resp.get("state", "unknown")).lower()
            print(f"Run state     : {state}")

            if state == "success":
                print("DAG run finished successfully.")
                return
            if state in {"failed"}:
                raise RuntimeError(f"DAG run failed. Response: {run_resp}")

            time.sleep(AIRFLOW_POLL_SECONDS)

        raise TimeoutError(f"Timed out waiting for DAG run completion after {AIRFLOW_WAIT_SECONDS}s")
    finally:
        if original_paused:
            try:
                print("Restoring DAG to paused state...")
                _request(session, "PATCH", f"{api_base}/dags/{dag_id}", json={"is_paused": True})
            except Exception as exc:  # keep original exception if any, but log restore errors
                print(f"Warning: failed to re-pause DAG: {exc}")


if __name__ == "__main__":
    main()
