{ pkgs, dir, links, ... }:
{
  environment.systemPackages = with pkgs; [
    python3
    uv
  ];

  systemd.tmpfiles.rules = links {
    ".config/uv" = "${dir}/uv";
  };
}
