{ pkgs, lib, ... }:
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


    default="$out/share/icons/default"
    mkdir -p "$default"
    chmod -R u+w "$default"

    cat > "$default/index.theme" <<EOF
    [Icon Theme]
    Name=default
    Comment=Default cursor theme
    EOF

    cat > "$default/cursor.theme" <<EOF
    [Icon Theme]
    Name=default
    Comment=Default cursor theme
    Inherits=${cursorTheme}
    EOF

    chmod 644 "$default/index.theme" "$default/cursor.theme"
  '';
in
{
  environment.systemPackages = [
    pkgs.whitesur-icon-theme
    cursors
  ];

  environment.sessionVariables = {
    XCURSOR_THEME = cursorTheme;
    XCURSOR_SIZE = toString cursorSize;
  };

  # noctalia greeter cursor
  # umbriel cursor set in umbriel/config.toml
  services.displayManager.noctalia-greeter.settings.cursor = {
    theme = cursorTheme;
    size = cursorSize;
    path = "/run/current-system/sw/share/icons";
  };

  programs.dconf = {
    enable = true;
    profiles.user.databases = [
      {
        settings."org/gnome/desktop/interface" = {
          icon-theme = iconTheme;
          cursor-theme = cursorTheme;
          cursor-size = lib.gvariant.mkInt32 cursorSize;
        };
      }
    ];
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
}
