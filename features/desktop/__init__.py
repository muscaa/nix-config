from pathlib import Path

from rig import command, argument

@command(root=True)
@argument("--stats", action="store_true")
def media(args):
    """Media library status."""
    print("library status", "(with stats)" if args.stats else "")

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
