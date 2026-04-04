import os

import requests
import uuid
from datetime import datetime, timezone

# Langfuse API endpoint and keys
os.environ.setdefault("LANGFUSE_BASE_URL", os.environ.get("LANGFUSE_BASE_URL", "http://localhost:3080"))
os.environ.setdefault("PUBLIC_KEY", os.environ.get("PUBLIC_KEY", "pk-lf-d62f409f-366e-498e-9484-82454df9e8c4"))
os.environ.setdefault("SECRET_KEY", os.environ.get("SECRET_KEY", "sk-lf-a6338281-aae0-49b5-9a07-3914a23069e7"))

# Example trace data
def send_trace():
    trace_id = str(uuid.uuid4())
    url = f"{os.environ['LANGFUSE_BASE_URL']}/api/public/traces"
    headers = {
        "Content-Type": "application/json",
    }
    payload = {
        "id": trace_id,
        "name": "example-trace",
        "input": {"foo": "bar"},
        "output": {"result": "success"},
        "timestamp": datetime.now(timezone.utc).isoformat().replace("+00:00", "Z"),
        "metadata": {"source": "script"}
    }
    response = requests.post(url, json=payload, headers=headers, auth=(os.environ['PUBLIC_KEY'], os.environ['SECRET_KEY']))
    print(f"Status: {response.status_code}")
    print(f"Response: {response.text}")

if __name__ == "__main__":
    send_trace()
