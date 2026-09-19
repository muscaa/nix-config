{ pkgs, inputs, dir, ... }:
{
  environment.systemPackages = with pkgs; [
    fastfetch
  ];
}
