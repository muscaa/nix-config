{ lib, inputs }:
let
  utils = import ./utils.nix { inherit lib; };
  features = utils.features;

  # makes a nixos configuration
  mkNixos =
    name:
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs features name;
      };
      modules = [
        (inputs.import-tree ./modules)
        (utils.getHost name)
      ];
    };

  # makes a darwin configuration
  # mkDarwin =
  #   name:
  #   inputs.nix-darwin.lib.darwinSystem {
  #     specialArgs = {
  #       inherit inputs features name;
  #     };
  #     modules = [
  #       (inputs.import-tree ./modules)
  #       (utils.getHost name)
  #     ];
  #   };
in
{
  nixos = lib.genAttrs [
    "nixos"
  ] mkNixos;

  # darwin = lib.genAttrs [
  #   "musca-mba"
  # ] mkDarwin;
}
