{ config, pkgs, inputs, ... }: {
  imports = [
    inputs.mt7927.nixosModules.default
  ];

  hardware.mediatek-mt7927 = {
    enable = true;
    enableWifi = true;
    enableBluetooth = false;
    disableAspm = true;
  };

  #hardware.bluetooth.enable = true;
  #hardware.bluetooth.powerOnBoot = true;
  #hardware.bluetooth.settings = {
    #General = {
      #Experimental = true;
      #FastConnectable = true;
    #};
  #};
  #services.blueman.enable = true;

  networking = {
    hostName = "nixos";
    useDHCP = false;

    # wireless.enable = true;

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

    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    firewall = {
      enable = false;
      # allowedTCPPorts = [ ... ];
      # allowedUDPPorts = [ ... ];
    };
  };
}
