{ config, lib, ... }:

let
  cfg = config.local.privilege;

  renderPolkitRule =
    _: rule: ''
      polkit.addRule(function(action, subject) {
        if (
          subject.isInGroup(${builtins.toJSON rule.group})
          && action.id.indexOf(${builtins.toJSON rule.actionPrefix}) == 0
        ) {
          return polkit.Result.YES;
        }
      });
    '';
in
{
  options.local.privilege = {
    backend = lib.mkOption {
      type = lib.types.enum [ "none" ];
      default = "none";
      description = "Selected backend implementing interactive privilege escalation";
    };

    polkitRules = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            group = lib.mkOption {
              type = lib.types.str;
              description = "Unix group authorized by this rule";
            };

            actionPrefix = lib.mkOption {
              type = lib.types.str;
              description = "Polkit action ID prefix granted to the group";
            };
          };
        }
      );
      default = { };
      description = "Declarative polkit authorization rules";
    };
  };

  config = {
    services.polkit.extraConfig = lib.mkIf (cfg.polkitRules != { }) (
      lib.concatStringsSep "\n" (lib.mapAttrsToList renderPolkitRule cfg.polkitRules)
    );

    assertions = [
      {
        assertion = cfg.polkitRules == { } || (config.services.polkit.enable or false);
        message = "privilege: polkitRules are declared, but services.polkit is not enabled";
      }
    ];
  };
}
