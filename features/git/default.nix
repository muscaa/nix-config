{ pkgs, inputs, dir, ... }:
{
  environment.systemPackages = with pkgs; [
    gh
    gnupg
  ];

  programs = {
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
    gnupg.agent.enable = true;
  };

  #environment.shellInit = ''
    #export GPG_TTY=$(tty)
  #'';
}
