{
  pkgs,
  dir,
  links,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    vesktop
  ];

  systemd.tmpfiles.rules = links {
    ".config/vesktop/themes" = "${dir}/themes";
  };
}
