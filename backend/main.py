from fastapi import FastAPI
from pydantic import BaseModel
from pathlib import Path
from datetime import datetime
import hashlib
import json

app = FastAPI()

class Capture(BaseModel):
    url: str
    content: str

LOG_PATH = Path("captures/log.jsonl")

@app.post("/api/save")
async def save_capture(capture: Capture):
    """Save the given capture to a JSONL log with a SHA256 hash."""
    LOG_PATH.parent.mkdir(parents=True, exist_ok=True)

    sha = hashlib.sha256(capture.content.encode("utf-8")).hexdigest()
    record = {
        "ts": datetime.utcnow().isoformat(),
        "url": capture.url,
        "content": capture.content,
        "sha256": sha,
    }

    with LOG_PATH.open("a", encoding="utf-8") as f:
        f.write(json.dumps(record, ensure_ascii=False) + "\n")

    return {"status": "ok", "hash": sha}
