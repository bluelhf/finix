{ config, lib, ... }:

let
  cfg = config.local.grants;

  unknownGrants = lib.concatLists (
    lib.mapAttrsToList (
      user: grants:
      map (grant: { inherit user grant; }) (
        lib.filter (grant: !(cfg.groups ? ${grant})) (lib.unique grants)
      )
    ) cfg.users
  );
in
{
  options.local.grants = {
    groups = lib.mkOption {
      type = lib.types.attrsOf (lib.types.listOf lib.types.str);
      default = { };
      description = "Mapping from abstract capability grant name to concrete Unix groups";
    };

    users = lib.mkOption {
      type = lib.types.attrsOf (lib.types.listOf lib.types.str);
      default = { };
      example.ilari = [
        "admin"
        "graphics"
        "seat"
        "input"
        "network"
      ];
      description = "Capability grants assigned to each principal by the host";
    };
  };

  config = {
    local.grants.groups = {
      admin = [ "wheel" ];
      graphics = [ "video" ];
      input = [ "input" ];
    };

    users.users = lib.mapAttrs (
      _: grants: {
        extraGroups = lib.unique (
          lib.concatMap (grant: cfg.groups.${grant} or [ ]) grants
        );
      }
    ) cfg.users;

    assertions = map (
      { user, grant }:
      {
        assertion = false;
        message = "grants: user '${user}' was granted unknown capability '${grant}' (available: ${lib.concatStringsSep ", " (lib.attrNames cfg.groups)})";
      }
    ) unknownGrants;
  };
}
