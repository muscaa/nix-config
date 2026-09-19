{ pkgs, inputs, dir, ... }:
{
  environment.systemPackages = with pkgs; [
    nodejs
  ];

  environment.sessionVariables = {
    NPM_CONFIG_PREFIX = "$HOME/.npm-global";
    PATH = [ "$HOME/.npm-global/bin" ];
  };
}
