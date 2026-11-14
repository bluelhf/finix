{ config, lib, ... }:

let
  identity = config.local.git.identity;
in
{
  imports = [ ./git-identity.nix ];

  programs.git = {
    enable = true;

    settings.user = lib.filterAttrs (_: v: v != null) {
      inherit (identity) name email;
    };

    signing = lib.mkIf (identity.signingKey != null) {
      format = "ssh";
      key = identity.signingKey;
      signByDefault = true;
    };
  };
}
