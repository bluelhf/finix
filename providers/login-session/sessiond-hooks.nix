{ config, lib, modules, ... }:

let
  cfg = config.local.loginSession;
  enabledServices = lib.filterAttrs (_: svc: svc.enable) cfg.services;
in
{
  imports = [ modules.sessiond-hooks ];

  options.local.loginSession.backend = lib.mkOption {
    type = lib.types.enum [ "sessiond-hooks" ];
  };

  config = lib.mkMerge [
    {
      local.loginSession.backend = lib.mkDefault "sessiond-hooks";
    }

    (lib.mkIf (cfg.backend == "sessiond-hooks") {
      local.loginSession.supportedFeatures.restart = true;
      local.capabilities.required = [ "session-manager" ];

      services.sessiond-hooks = {
        enable = true;
        hooks = lib.mapAttrs (
          _: svc: {
            settings = {
              on_start = svc.command;
            }
            // lib.optionalAttrs (svc.restart == "on-failure") {
              restart = {
                on = "Failure";
                delay = svc.restartDelay;
              };
            };
          }
        ) enabledServices;
      };
    })
  ];
}
