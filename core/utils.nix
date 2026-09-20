{ lib }:
let
  paths = import ./paths.nix;
in
rec {
  # returns a feature module file
  getFeature =
    name:
    let
      dir = paths.features + "/${name}";
    in
    assert builtins.pathExists (dir + "/default.nix") || throw "rig: no such feature: ${name}";
    dir;

  # returns a host module file
  getHost =
    name:
    let
      dir = paths.hosts + "/${name}";
    in
    assert builtins.pathExists (dir + "/default.nix") || throw "rig: no such host: ${name}";
    dir;

  # makes the links function
  mkLinks =
    {
      user,
      group,
      srcBase,
      destBase,
    }:
    paths:
    let
      resolved = lib.mapAttrsToList (src: dest: {
        src = if lib.hasPrefix "/" src then src else "${srcBase}/${src}";
        dest = if lib.hasPrefix "/" dest then dest else "${destBase}/${dest}";
      }) paths;

      parents = lib.unique (
        lib.filter (path: lib.hasPrefix "${srcBase}/" path && path != srcBase) (
          map (link: dirOf link.src) resolved
        )
      );

      dirRules = map (path: "d ${path} 0755 ${user} ${group} -") parents;
      linkRules = map (link: "L+ ${link.src} - - - - ${link.dest}") resolved;
    in
    dirRules ++ linkRules;

  # maps feature names to feature modules
  features =
    names:
    map (
      name:
      {
        config,
        options,
        lib,
        pkgs,
        modulesPath,
        inputs,
        ...
      }@args:
      let
        rig = config.rig;
      in
      import (getFeature name) (
        args
        // {
          dir = "${rig.path}/features/${name}";
          links = mkLinks {
            user = rig.user;
            group = rig.group;
            srcBase = "/home/${rig.user}";
            destBase = rig.path;
          };
        }
      )
    ) names;
}
