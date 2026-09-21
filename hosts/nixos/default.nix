{ pkgs, features, ... }:
{
  imports = [
    ./hardware.nix
    ./system.nix
    ./fixes.nix
  ]
  ++ features [
    # system
    "plymouth"
    "desktop"

    # tools
    "zsh"
    "dev-tools"

    # apps
    "discord"
    "min-apps"
    "spotify"
    "steam"
    "sunshine"
  ];

  rig.system = "x86_64-linux";
  rig.user = "musca";
  rig.group = "users";
  rig.path = "/home/musca/.config/nixos";

  # users
  users.defaultUserShell = pkgs.zsh;
  users.users."musca" = {
    isNormalUser = true;
    description = "musca";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  # network config
  networking = {
    useDHCP = false;
    firewall.enable = false;

    networkmanager = {
      enable = true;
      ensureProfiles.profiles.wired = {
        connection = {
          id = "wired";
          type = "ethernet";
          interface-name = "enp112s0";
          autoconnect = true;
        };
        ipv4 = {
          method = "manual";
          addresses = "192.168.0.100/24";
          gateway = "192.168.0.1";
          dns = "192.168.0.1;1.1.1.1";
        };
        ipv6.method = "auto";
      };
    };
  };

  # extra boot options
  boot.loader.systemd-boot = {
    enable = true;
    edk2-uefi-shell.enable = true;
    windows."11" = {
      title = "Windows 11";
      efiDeviceHandle = "HD0b";
    };
  };
}
