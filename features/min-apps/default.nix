{
  pkgs,
  dir,
  links,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    # terminal
    kitty

    # file explorer
    nautilus

    # ide
    vscode

    # image viewer
    loupe
  ];

  # printing
  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # browser
  programs.firefox = {
    enable = true;
  };

  # network file transfer
  programs.localsend = {
    enable = true;
  };

  systemd.tmpfiles.rules = links {
    ".config/kitty" = "${dir}/kitty";
  };
}
