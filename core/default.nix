{ lib, inputs, ... }:
let
  hosts = import ./hosts.nix { inherit lib inputs; };
in
{
  systems = [
    "x86_64-linux"
    "aarch64-linux"
    "x86_64-darwin"
    "aarch64-darwin"
  ];

  perSystem =
    { ... }:
    { };

  flake = {
    nixosConfigurations = hosts.nixos;
    # darwinConfigurations = hosts.darwin;
  };
}
