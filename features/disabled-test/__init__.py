from pathlib import Path

from rig import command

@command
def test(args):
    """Test command."""
    print("test", args.args)
