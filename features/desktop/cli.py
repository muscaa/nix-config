from typing import Callable, Literal, get_args
import typer

from features.desktop import events as e

desktop = typer.Typer()

Event = Literal[
    "umbriel_start",
    "noctalia_start",
    "noctalia_logout",
    "noctalia_reboot",
    "noctalia_shutdown",
]
EVENTS: dict[Event, Callable[[], None]] = {
    "umbriel_start": e.umbriel_start,
    "noctalia_start": e.noctalia_start,
    "noctalia_logout": e.noctalia_logout,
    "noctalia_reboot": e.noctalia_reboot,
    "noctalia_shutdown": e.noctalia_shutdown,
}
assert set(get_args(Event)) == EVENTS.keys()

@desktop.command()
def events(name: Event):
    EVENTS[name]()
