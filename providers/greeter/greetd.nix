{ config, lib, pkgs, modules, ... }:

let
  cfg = config.local.greeter;
in
{
  imports = [ modules.greetd ];

  options.local.greeter.backend = lib.mkOption {
    type = lib.types.enum [ "greetd" ];
  };

  config = lib.mkMerge [
    {
      local.greeter.backend = lib.mkDefault "greetd";
    }

    (lib.mkIf (cfg.backend == "greetd") {
      local.greeter.pamService = "greetd";

      services.greetd = {
        enable = true;
        settings.default_session.command = "${lib.getExe pkgs.tuigreet}";
      };

      security.pam.services.greetd.text = lib.mkMerge [
        (lib.mkIf (cfg.pamAuthBefore != "") (lib.mkBefore cfg.pamAuthBefore))
        (lib.mkIf (cfg.pamSessionAfter != "") (lib.mkAfter cfg.pamSessionAfter))
      ];
    })
  ];
}
