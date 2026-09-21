{
  inputs,
  dir,
  links,
  ...
}:
{
  imports = [
    inputs.spicetify-nix.nixosModules.spicetify
  ];

  programs.spicetify = {
    enable = true;
    theme = {
      name = "Comfy";
      src = ./Themes/Comfy;
    };
    colorScheme = "Comfy";
  };

  systemd.tmpfiles.rules = links {
    ".config/spicetify" = dir;
  };
}
