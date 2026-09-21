import importlib
import pkgutil

def load():
    import features
    found = {}
    for info in pkgutil.iter_modules(features.__path__):
        found[info.name] = importlib.import_module(f"{features.__name__}.{info.name}")
    return found
