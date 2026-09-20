import argparse
import importlib
import pkgutil

COMMANDS = {}

def command(fn=None, *, name=None):
    """Register a subcommand. Usable bare or with a name."""
    def deco(f):
        COMMANDS[name or f.__name__.replace("_", "-")] = f
        return f
    return deco(fn) if fn is not None else deco

def load_features():
    from . import features
    found = {}
    for info in pkgutil.iter_modules(features.__path__):
        found[info.name] = importlib.import_module(f"{features.__name__}.{info.name}")
    return found

def main(argv=None):
    load_features()

    parser = argparse.ArgumentParser(prog="rig")
    sub = parser.add_subparsers(dest="cmd", required=True)
    for name, fn in sorted(COMMANDS.items()):
        p = sub.add_parser(name, help=(fn.__doc__ or "").strip())
        p.add_argument("args", nargs="*")
        p.set_defaults(_fn=fn)

    args = parser.parse_args(argv)
    return args._fn(args) or 0
