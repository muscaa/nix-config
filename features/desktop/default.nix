{ pkgs, lib, inputs, dir, links, ... }:
let
  iconTheme = "WhiteSur-dark";
  cursorTheme = "musca";
  cursorSize = 24;
  cursors = pkgs.runCommand "${cursorTheme}-cursors" { } ''
    theme1="${pkgs.apple-cursor}/share/icons/macOS"
    theme2="${pkgs.bibata-cursors}/share/icons/Bibata-Original-Classic"

    if [ ! -d "$theme1" ]; then echo "missing theme $theme1" >&2; exit 1; fi
    if [ ! -d "$theme2" ]; then echo "missing theme $theme2" >&2; exit 1; fi

    dest="$out/share/icons/${cursorTheme}"
    mkdir -p "$dest"
    cp -r "$theme1/." "$dest/"
    chmod -R u+w "$dest"

    cursors="$dest/cursors"

    left_ptr="$theme2/cursors/left_ptr"
    cp $left_ptr "$cursors/left_ptr"

    cat > "$dest/index.theme" <<EOF
    [Icon Theme]
    Name=${cursorTheme}
    Comment=${cursorTheme} combined cursor theme
    EOF

    cat > "$dest/cursor.theme" <<EOF
    [Icon Theme]
    Name=${cursorTheme}
    Comment=${cursorTheme} combined cursor theme
    Inherits=${cursorTheme}
    EOF

    chmod 644 "$dest/index.theme" "$dest/cursor.theme"
  '';
  defaultCursor = pkgs.writeTextDir "share/icons/default/index.theme" ''
    [Icon Theme]
    Name=default
    Comment=Default cursor theme
    Inherits=${cursorTheme}
  '';
in
{
  imports = [
    inputs.noctalia-greeter.nixosModules.default
    inputs.umbriel.nixosModules.default
    inputs.noctalia.nixosModules.default
  ];

  # Nice boot screen
  boot = {
    plymouth.enable = true;

    consoleLogLevel = 0;

    initrd = {
      verbose = false;
      kernelModules = [ "amdgpu" ];
    };

    kernelParams = [
      "quiet"
      "splash"
      "udev.log_priority=3"
    ];
  };

  # Noctalia greeter
  services.displayManager.noctalia-greeter = {
    enable = true;
    passwordless-sync-users = [ "musca" ];
    settings = {
      appearance = {
        hide_logo = true;
        scheme_selector_position = "hidden";
      };
      cursor = {
        theme = cursorTheme;
        size = cursorSize;
        path = "/run/current-system/sw/share/icons";
      };
      keyboard = {
        layout = "us";
        numlock = false;
      };
    };
  };

  services.greetd.settings.initial_session = {
    command = "start-umbriel";
    user = "musca";
  };

  # Umbriel Compositor
  programs.umbriel.enable = true;

  # Noctalia Shell (not shell anymore btw)

  #security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    #alsa.enable = true;
    pulse.enable = true;
    #wireplumber.enable = true;
  };

  hardware.bluetooth.enable = true;

  #services.power-profiles-daemon.enable = true;
  #services.upower.enable = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  environment.systemPackages = [
    pkgs.whitesur-icon-theme
    cursors
    defaultCursor
  ];

  programs.noctalia = {
    enable = true;

    recommendedServices.enable = true;
  };

  programs.dconf = {
    enable = true;
    profiles.user.databases = [{
      settings."org/gnome/desktop/interface" = {
        icon-theme = iconTheme;
        cursor-theme = cursorTheme;
        cursor-size = lib.gvariant.mkInt32 cursorSize;
      };
    }];
  };

  environment.etc = {
    "xdg/gtk-3.0/settings.ini".text = ''
      [Settings]
      gtk-icon-theme-name=${iconTheme}
      gtk-cursor-theme-name=${cursorTheme}
      gtk-cursor-theme-size=${toString cursorSize}
    '';
    "xdg/gtk-4.0/settings.ini".text = ''
      [Settings]
      gtk-icon-theme-name=${iconTheme}
      gtk-cursor-theme-name=${cursorTheme}
      gtk-cursor-theme-size=${toString cursorSize}
    '';
  };

  environment.sessionVariables = {
    XCURSOR_THEME = cursorTheme;
    XCURSOR_SIZE = toString cursorSize;
  };

  environment.etc."libinput/local-overrides.quirks".text = ''
    [Logitech G502 Wireless]
    MatchName=*G502*
    MatchUdevType=mouse
    AttrEventCode=-REL_WHEEL_HI_RES;-REL_HWHEEL_HI_RES;
  '';

  systemd.tmpfiles.rules = links {
    ".config/umbriel" = "${dir}/umbriel";
    ".config/noctalia" = "${dir}/noctalia";
    ".config/gtk-3.0" = "${dir}/gtk-3.0";
    ".config/gtk-4.0" = "${dir}/gtk-4.0";
    ".config/qt5ct" = "${dir}/qt5ct";
    ".config/qt6ct" = "${dir}/qt6ct";
  };
}
