{ lib, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableBashCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    histFile = "$HOME/.local/state/zsh/history";
    histSize = 10000;

    ohMyZsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [
        "git"
      ];
      cacheDir = "$HOME/.cache/oh-my-zsh";
    };

    promptInit = "";
    shellInit = ''
      zsh-newuser-install() { :; }
      export ZSH_COMPDUMP="$HOME/.cache/zsh/zcompdump-$ZSH_VERSION"
      zstyle ':omz:update' mode disabled
    '';

    interactiveShellInit = lib.mkBefore ''
      mkdir -p "$HOME/.local/state/zsh" "$HOME/.cache/zsh"
    '';
  };
}
