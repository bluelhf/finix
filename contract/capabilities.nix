{ config, lib, ... }:

let
  cfg = config.local.capabilities;

  activeProviders = lib.filterAttrs (_: p: p.enable) cfg.providers;

  providersByCapability = lib.foldlAttrs (
    acc: name: provider:
    lib.foldl' (
      inner: cap:
      inner // { ${cap} = (inner.${cap} or [ ]) ++ [ name ]; }
    ) acc (lib.unique provider.provides)
  ) { } activeProviders;

  missing = lib.filter (
    cap: !(providersByCapability ? ${cap})
  ) (lib.unique cfg.required);

  colliding = lib.filterAttrs (
    cap: providers: lib.elem cap cfg.exclusive && builtins.length providers > 1
  ) providersByCapability;
in
{
  options.local.capabilities = {
    providers = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            enable = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Whether this provider is active";
            };

            provides = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [ ];
              description = "Capabilities jointly provided by this component";
            };
          };
        }
      );
      default = { };
      description = "Components and the capability traits they provide";
    };

    required = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Capabilities that must be provided by at least one active provider";
    };

    exclusive = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Capabilities that at most one active provider may provide";
    };

    provided = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      readOnly = true;
      default = builtins.attrNames providersByCapability;
      description = "Capabilities provided by currently active providers";
    };

    byCapability = lib.mkOption {
      type = lib.types.attrsOf (lib.types.listOf lib.types.str);
      readOnly = true;
      default = providersByCapability;
      description = "Map from capability name to active provider names";
    };
  };

  config.assertions =
    (map (cap: {
      assertion = false;
      message = "capabilities: required capability '${cap}' has no active provider";
    }) missing)
    ++ (lib.mapAttrsToList (cap: providers: {
      assertion = false;
      message = "capabilities: exclusive capability '${cap}' is provided by multiple providers: ${lib.concatStringsSep ", " providers}";
    }) colliding);
}
