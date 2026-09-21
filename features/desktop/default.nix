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

    # for themes, cant be set in ./theme.nix
    ".config/gtk-3.0" = "${dir}/gtk-3.0";
    ".config/gtk-4.0" = "${dir}/gtk-4.0";
    ".config/qt5ct" = "${dir}/qt5ct";
    ".config/qt6ct" = "${dir}/qt6ct";
  };
}
