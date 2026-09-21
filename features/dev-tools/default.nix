{
  pkgs,
  dir,
  links,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    # nix
    nixfmt
    nixd

    # python
    python3
    uv

    # js
    nodejs

    # c/c++
    gcc

    # git/github
    gh
    gnupg

    # other
    fastfetch
  ];

  # ssh
  services.openssh.enable = true;

  # git/github
  programs = {
    gnupg.agent.enable = true;
    git = {
      enable = true;
      config = {
        user = {
          name = "Musca Mihail";
          email = "muscamihaill@gmail.com";
          signingkey = "BD6BA5ED89E12513";
        };
        commit.gpgsign = true;
        tag.gpgsign = true;
      };
    };
  };

  environment.sessionVariables = {
    NPM_CONFIG_PREFIX = "$HOME/.npm-global";
    PATH = [ "$HOME/.npm-global/bin" ];
  };

  systemd.tmpfiles.rules = links {
    ".config/uv" = "${dir}/uv";
  };
}
