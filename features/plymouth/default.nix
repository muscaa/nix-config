{ ... }:
{
  # nice boot screen
  boot = {
    plymouth.enable = true;

    consoleLogLevel = 0;

    initrd = {
      verbose = false;
      kernelModules = [ "amdgpu" ];
    };

    kernelParams = [
      "quiet"
      "splash"
      "udev.log_priority=3"
    ];
  };
}
