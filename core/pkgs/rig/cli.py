import subprocess
import typer

rig = typer.Typer(
    name="rig",
    add_completion=False,
)

nix = typer.Typer(name="nix")
rig.add_typer(nix)

@nix.command()
def rebuild():
    subprocess.run(
        ["sudo", "nixos-rebuild", "switch"],
        check=True,
    )

@nix.command()
def upgrade():
    subprocess.run(
        ["sudo", "nix", "flake", "update"],
        check=True,
    )
    rebuild()

@nix.command()
def profiles():
    result = subprocess.run(
        ["sudo", "nix-env", "--list-generations", "--profile", "/nix/var/nix/profiles/system"],
        check=True,
        capture_output=True,
        text=True,
    )
    print(result.stdout)
