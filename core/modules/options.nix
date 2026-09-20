{ config, lib, ... }:
{
  options.rig = {
    system = lib.mkOption {
      type = lib.types.enum [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      description = "Architecture of this host.";
    };

    user = lib.mkOption {
      type = lib.types.nonEmptyStr;
      description = "Current hostname user.";
    };

    group = lib.mkOption {
      type = lib.types.nonEmptyStr;
      description = "Current hostname group.";
    };

    path = lib.mkOption {
      type = lib.types.addCheck lib.types.nonEmptyStr (lib.hasPrefix "/");
      description = "Absolute path to this repo on the live filesystem.";
    };

    # internal use
    internal = lib.mkOption {
      type = lib.types.submodule {
        options = {
          features = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ ];
            description = "Feature names imported on this host.";
          };
        };
      };
      default = {};
      description = "Internal rig options.";
    };
  };

  config = {
    assertions = [
      {
        assertion = !(lib.hasSuffix "/" config.rig.path);
        message = "rig.path must not end in a slash (got \"${config.rig.path}\").";
      }
      {
        assertion = lib.hasAttr config.rig.user config.users.users;
        message = "rig.user is \"${config.rig.user}\" but no such user is defined.";
      }
    ];

    nixpkgs.hostPlatform = config.rig.system;

    system.activationScripts.rigPath.text = ''
      [ -d "${config.rig.path}" ] \
        || echo "rig: ${config.rig.path} does not exist; configs will not apply" >&2
    '';
  };
}
