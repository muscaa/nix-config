{ pkgs, options, ... }:
{
  programs.nix-ld = {
    enable = true;
    libraries =
      options.programs.nix-ld.libraries.default
      ++ (with pkgs; [
        libGL
        libpulseaudio
        libX11
        libXcursor
        libXrandr
        libXi
        freetype
        fontconfig
      ]);
  };
}
