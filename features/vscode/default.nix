{ pkgs, inputs, dir, ... }:
{
  environment.systemPackages = with pkgs; [
    vscode
  ];
}
