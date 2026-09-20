{
  lib,
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

  dirsIn = root: lib.attrNames (lib.filterAttrs (_: t: t == "directory") (builtins.readDir root));

  hasPython = name: builtins.pathExists (paths.features + "/${name}/__init__.py");

  enabled = lib.filter (name: hasPython name) (dirsIn paths.features);

  rig = pkgs.callPackage (paths.pkgs + "/rig") {
    features = lib.genAttrs enabled (name: extract (paths.features + "/${name}"));
  };
in
{
  environment.systemPackages = [ rig ];
}
