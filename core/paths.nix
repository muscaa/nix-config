rec {
  root = ../.;
  features = root + "/features";
  hosts = root + "/hosts";
  pkgs = ./pkgs;
}
