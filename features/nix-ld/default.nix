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
        vulkan-loader
        wayland
        libxkbcommon
        libdecor
        libXext
        libXfixes
        libXScrnSaver
        alsa-lib
        openal
      ]);
  };

  environment.sessionVariables.LD_LIBRARY_PATH = "/run/current-system/sw/share/nix-ld/lib";
}
