{ config, lib, ... }:

let
  cfg = config.local.loginSession;
  enabledServices = lib.filterAttrs (_: svc: svc.enable) cfg.services;
  restartingServices = lib.filterAttrs (_: svc: svc.restart != "never") enabledServices;
in
{
  options.local.loginSession = {
    backend = lib.mkOption {
      type = lib.types.enum [ "none" ];
      default = "none";
      description = "Selected backend implementing the login-session service lifetime";
    };

    supportedFeatures = {
      restart = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether the selected backend supports restarting failed services";
      };
    };

    services = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            enable = lib.mkEnableOption "login-session service";

            command = lib.mkOption {
              type = lib.types.str;
              description = "Command to run for the lifetime of the login session";
            };

            restart = lib.mkOption {
              type = lib.types.enum [ "never" "on-failure" ];
              default = "never";
              description = "Restart policy if the service exits unexpectedly";
            };

            restartDelay = lib.mkOption {
              type = lib.types.int;
              default = 5;
              description = "Seconds to wait before restarting a failed service";
            };
          };
        }
      );
      default = { };
      description = "Per-principal services bound to the login session lifetime";
    };
  };

  config.assertions = [
    {
      assertion = enabledServices == { } || cfg.backend != "none";
      message = "loginSession: services are enabled (${lib.concatStringsSep ", " (lib.attrNames enabledServices)}), but local.loginSession.backend is 'none'";
    }
    {
      assertion = restartingServices == { } || cfg.supportedFeatures.restart;
      message = "loginSession: services request restart (${lib.concatStringsSep ", " (lib.attrNames restartingServices)}), but backend '${cfg.backend}' does not support restart";
    }
  ];
}
