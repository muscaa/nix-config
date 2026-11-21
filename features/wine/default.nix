{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    wineWow64Packages.stable
    (writeShellScriptBin "wine64" ''exec wine "$@"'')
    curl
    wget
    p7zip
  ];

  environment.sessionVariables.MGFXC_WINE_PATH = "$HOME/.winemonogame";
}
