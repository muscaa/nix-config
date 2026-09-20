from pathlib import Path

from rig import command, argument

@command
@argument("--depth", type=int, default=3)
def scan(args):
    """Rescan the media library."""
    print("scanning, depth", args.depth)

@command(group=scan)
@argument("--force", action="store_true")
def cache(args):
    """Rebuild the scan cache."""
    print("rebuilding cache")
