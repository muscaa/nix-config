import os
import subprocess
import sys
from pathlib import Path
import time

#
# utils
#
def launch(cmd, log=None, cwd=None, env=None):
    """Start cmd detached from this process. Returns the child's PID."""
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
        if out is not subprocess.DEVNULL:
            out.close()  # the child has its own copy of the fd

    return p.pid

#
# events
#
def umbriel_start():
    pass

def noctalia_start():
    time.sleep(1.5)
    launch(["spotify"])
    launch(["vesktop"])

def noctalia_logout():
    pass

def noctalia_reboot():
    pass

def noctalia_shutdown():
    pass

#
# main
#
COMMANDS = {
    "umbriel_start": umbriel_start,
    "noctalia_start": noctalia_start,
    "noctalia_logout": noctalia_logout,
    "noctalia_reboot": noctalia_reboot,
    "noctalia_shutdown": noctalia_shutdown,
}

if __name__ == "__main__":
    name = sys.argv[1] if len(sys.argv) > 1 else None
    fn = COMMANDS.get(name)

    if fn is None:
        print(f"usage: {sys.argv[0]} {{{'|'.join(COMMANDS)}}}", file=sys.stderr)
        sys.exit(1)

    fn()
