{
  lib,
  config,
  pkgs,
  paths,
  ...
}:
let
  # extract python files
  extract =
    src:
    lib.fileset.toSource {
      root = src;
      fileset = lib.fileset.fileFilter (f: f.hasExt "py") src;
    };

  # python features
  hasPython = name: builtins.pathExists (paths.features + "/${name}/__init__.py");
  enabled = lib.filter hasPython (lib.unique config.rig.internal.features);

  # rig package
  rig = pkgs.callPackage (paths.pkgs + "/rig") {
    features = lib.genAttrs enabled (name: extract (paths.features + "/${name}"));
  };
in
{
  environment.systemPackages = [ rig ];
}
