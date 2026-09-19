{ pkgs, inputs, dir, ... }:
{
  services.openssh.enable = true;

  services.sunshine = {
    enable = true;
    autoStart = false;    # we'll launch it from Umbriel instead
    capSysAdmin = true;   # CAP_SYS_ADMIN, required for KMS capture on Wayland
    openFirewall = true;
  };
}
