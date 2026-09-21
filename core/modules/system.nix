{ config, name, ... }:
{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.hostPlatform = config.rig.system;

  networking.hostName = name;
}
