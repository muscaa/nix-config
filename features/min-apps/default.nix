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
