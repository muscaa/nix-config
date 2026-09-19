{ inputs, lib, ... }:
let
  # utils
  feature = name:
    let
      dir = ../features + "/${name}";
    in
    assert builtins.pathExists (dir + "/default.nix") || throw "rig: no such feature: ${name}";
    dir;

  host = name:
    let
      dir = ../hosts + "/${name}";
    in
    assert builtins.pathExists (dir + "/default.nix") || throw "rig: no such host: ${name}";
    dir;

  features = names:
    map (
      name:
      let
        feat = feature name;
      in
      { config, optiosn, lib, pkgs, modulesPath, inputs, ... }@args:
      let
        rig = args.config.rig;
      in
      (import feat) (args // {
        dir = "${rig.path}/features/${name}";
        links = linksFor {
          user = rig.user;
          group = rig.group;
          srcBase = "/home/${rig.user}";
          destBase = rig.path;
        };
      })
    ) names;

  hosts = lib.filterAttrs (_: value: value == "directory") (builtins.readDir ../hosts);

  linksFor = { user, group, srcBase, destBase }:
    let
      resolve = base: path:
        if lib.hasPrefix "/" path
        then path
        else "${base}/${path}";
    in
    paths:
    let
      resolved = lib.mapAttrsToList (src: dest: {
        src = resolve srcBase src;
        dest = resolve destBase dest;
      }) paths;

      parents = lib.unique
        (lib.filter (path: lib.hasPrefix "${srcBase}/" path && path != srcBase)
          (map (link: builtins.dirOf link.src) resolved));

      dirRules = map
        (path: "d ${path} 0755 ${user} ${group} -") parents;

      linkRules = map
        (link: "L+ ${link.src} - - - - ${link.dest}") resolved;
    in
    dirRules ++ linkRules;

  # modules
  base = { config, ... }:
    {
      options.rig = {
        system = lib.mkOption {
          type = lib.types.str;
          description = "Architecture of this host.";
        };

        user = lib.mkOption {
          type = lib.types.str;
          description = "Current hostname user.";
        };

        group = lib.mkOption {
          type = lib.types.str;
          description = "Current hostname group.";
        };

        path = lib.mkOption {
          type = lib.types.str;
          description = ''
            Absolute path to this repo on the live filesystem.
            Plain string, never a Nix path.
          '';
        };
      };

      config = {
        nixpkgs.hostPlatform = config.rig.system;

        system.activationScripts.rigUser.text = ''
          [ -z "${config.rig.user}" ] \
            || echo "rig: rig.user missing; configs will not apply" >&2
        '';

        system.activationScripts.rigGroup.text = ''
          [ -z "${config.rig.group}" ] \
            || echo "rig: rig.group missing; configs will not apply" >&2
        '';

        system.activationScripts.rigPath.text = ''
          [ -d "${config.rig.path}" ] \
            || echo "rig: rig.path missing; configs will not apply" >&2
        '';
      };
    };

  # mks
  mkHost = name: _:
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs features;
      };
      modules = [
        base
        (host name)
      ];
    };

  #mkDarwin = name: _:
    #inputs.nix-darwin.lib.darwinSystem {
      #specialArgs = {
        #inherit inputs features;
      #};
      #modules = [
        #base
        #(host name)
      #];
    #};
in
{
  systems = [
    "x86_64-linux"
    #"aarch64-linux"
    #"x86_64-darwin"
    #"aarch64-darwin"
  ];

  perSystem = { pkgs, ... }:
    {
      formatter = pkgs.nixfmt-rfc-style;
      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          nixfmt-rfc-style
          nvd
          nix-tree
        ];
      };
    };

  flake = {
    nixosConfigurations = lib.mapAttrs mkHost hosts;
    #darwinConfigurations = lib.mapAttrs mkDarwin hosts;
  };
}
