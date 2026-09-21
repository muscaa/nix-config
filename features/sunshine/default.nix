{ ... }:
{
  services.sunshine = {
    enable = true;
    autoStart = false;
    capSysAdmin = true; # required for KMS capture on Wayland
    openFirewall = true;
  };
}
