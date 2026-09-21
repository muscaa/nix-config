import os
import subprocess
from collections.abc import Mapping, Sequence
from pathlib import Path
from typing import Literal
import json

type StrPath = str | os.PathLike[str]

def spawn(cmd: Sequence[StrPath], cwd: StrPath | None = None, env: Mapping[str, str] | None = None, log: StrPath | None = None):
    """Start cmd detached from this process. Returns the child's PID."""
    if not cmd:
        raise ValueError("cmd must not be empty")

    if log is None:
        out = subprocess.DEVNULL
    else:
        Path(log).parent.mkdir(parents=True, exist_ok=True)
        out = open(log, "ab", buffering=0)

    try:
        p = subprocess.Popen(
            cmd,
            cwd=cwd,
            env={**os.environ, **(env or {})},
            stdin=subprocess.DEVNULL,
            stdout=out,
            stderr=subprocess.STDOUT,
            start_new_session=True,
        )
    finally:
        if not isinstance(out, int):
            out.close()

    return p.pid

def notify(title: str, body: str = "", app: str = "", icon: str = "bell", urgency: Literal["low", "normal", "critical"] = "normal", timeout: float = 5):
    notification = {
        "app_name": app,
        "summary": title,
        "body": body,
        "urgency": urgency,
        "timeout_ms": timeout * 1000,
        "icon": icon,
    }

    subprocess.run(
        ["noctalia", "msg", "notification-show", json.dumps(notification)],
    )
