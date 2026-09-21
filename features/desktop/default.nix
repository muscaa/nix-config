{
  config,
  inputs,
  dir,
  links,
  ...
}:
{
  imports = [
    inputs.noctalia-greeter.nixosModules.default
    inputs.umbriel.nixosModules.default
    inputs.noctalia.nixosModules.default

    ./theme.nix
  ];

  # noctalia greeter
  services.displayManager.noctalia-greeter = {
    enable = true;
    passwordless-sync-users = [ config.rig.user ];
    settings = {
      appearance = {
        hide_logo = true;
        scheme_selector_position = "hidden";
      };
      keyboard = {
        layout = "us";
        numlock = false;
      };
    };
  };

  services.greetd.settings.initial_session = {
    command = "start-umbriel";
    user = config.rig.user;
  };

  # umbriel
  programs.umbriel.enable = true;

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # noctalia
  programs.noctalia = {
    enable = true;

    recommendedServices.enable = true;
  };

  systemd.tmpfiles.rules = links {
    ".config/umbriel" = "${dir}/umbriel";
    ".config/noctalia" = "${dir}/noctalia";
  };
}
