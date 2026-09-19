{ pkgs, inputs, dir, ... }:
{
  environment.systemPackages = with pkgs; [
    python3
  ];
}
