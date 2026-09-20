from rig import command

@command
def desktop(args):
    """Desktop cli tool."""
    print("desktop", args.args)
