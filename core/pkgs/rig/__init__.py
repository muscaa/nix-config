import argparse
import importlib
import pkgutil

_COMMANDS = []

def load_features():
    import features
    found = {}
    for info in pkgutil.iter_modules(features.__path__):
        found[info.name] = importlib.import_module(f"{features.__name__}.{info.name}")
    return found

def _first_line(doc):
    lines = (doc or "").strip().splitlines()
    return lines[0] if lines else None

def argument(*a, **kw):
    """Declare an argument for the command below it."""
    def deco(f):
        # decorators apply bottom-up; prepend to restore written order
        f._rig_args = [(a, kw)] + getattr(f, "_rig_args", [])
        return f
    return deco

def command(fn=None, *, name=None, group=None, help=None):
    """Register a subcommand.

    group: dotted path ("media.scan"), a parent command function,
           or None for the feature name. Pass group="" for top level.
    """
    def deco(f):
        if group is None:
            mod = f.__module__
            parts = (mod.split(".")[1],) if mod.startswith("features.") else ()
        elif callable(group):
            parts = getattr(group, "_rig_path")
        elif group:
            parts = tuple(group.split("."))
        else:
            parts = ()

        f._rig_path = parts + (name or f.__name__.replace("_", "-"),)
        _COMMANDS.append({
            "path": f._rig_path,
            "fn": f,
            "help": help or _first_line(f.__doc__),
            "args": getattr(f, "_rig_args", []),
        })
        return f
    return deco(fn) if fn is not None else deco

def build_parser():
    root = argparse.ArgumentParser(prog="rig")
    root.add_argument("-v", "--verbose", action="count", default=0)
    nodes = {(): {"parser": root, "subs": None, "fn": False}}

    def ensure(path, help=None):
        if path in nodes:
            return nodes[path]
        parent = ensure(path[:-1])
        if parent["subs"] is None:
            parent["subs"] = parent["parser"].add_subparsers(
                dest=f"_cmd{len(path)}",
                required=not parent["fn"],
            )
        p = parent["subs"].add_parser(
            path[-1], help=help or f"{path[-1]} commands")
        nodes[path] = {"parser": p, "subs": None, "fn": False}
        return nodes[path]

    for spec in sorted(_COMMANDS, key=lambda s: (len(s["path"]), s["path"])):
        node = ensure(spec["path"], spec["help"])
        for a, kw in spec["args"]:
            node["parser"].add_argument(*a, **kw)
        node["parser"].set_defaults(_fn=spec["fn"])
        node["fn"] = True

    return root

def main(argv=None):
    load_features()
    args = build_parser().parse_args(argv)
    return args._fn(args) or 0
