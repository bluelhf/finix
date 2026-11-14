{ lib, ... }:

{
  options.local.git.identity = {
    name = lib.mkOption {
      type = with lib.types; nullOr str;
      default = null;
      example = "Jane Doe";
      description = "name used for commit authorship";
    };

    email = lib.mkOption {
      type = with lib.types; nullOr str;
      default = null;
      example = "jane@example.com";
      description = "email used for commit authorship";
    };

    signingKey = lib.mkOption {
      type = with lib.types; nullOr str;
      default = null;
      example = "/home/jane/.ssh/id_ed25519";
      description = "ssh key used to sign commits and tags, signing is disabled when null";
    };
  };
}
