{ pkgs, features, lib, inputs, ... }:
{
  imports = [
    ./hardware.nix
    ./configuration.nix
    ./system.nix
    ./network.nix
  ] ++ features [
    "desktop"
    # apps
    "kitty"
    "nautilus"
    "firefox"
    "vscode"
    "localsend"
    "discord"
    "spotify"
    "steam"
    "loupe"
    # tools
    "git"
    "ssh"
    "fastfetch"
    "python3"
    "nodejs"
    "gcc"
  ];

  rig.system = "x86_64-linux";
  rig.user = "musca";
  rig.group = "users";
  rig.path = "/home/musca/.config/nixos";
}
