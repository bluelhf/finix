{ config, lib, ... }:

let
  cfg = config.local.displaySession;
  enabledServices = lib.filterAttrs (_: svc: svc.enable) cfg.services;
  restartingServices = lib.filterAttrs (_: svc: svc.restart != "never") enabledServices;
in
{
  options.local.displaySession = {
    backend = lib.mkOption {
      type = lib.types.enum [ "none" ];
      default = "none";
      description = "Selected backend implementing the display-session lifetime";
    };

    supportedFeatures = {
      restart = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether the selected backend supports restarting failed services";
      };
    };

    exportedVariables = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Environment variable names exported to the D-Bus activation environment on session start";
    };

    services = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            enable = lib.mkEnableOption "display-session service";

            command = lib.mkOption {
              type = lib.types.str;
              description = "Command to run for the lifetime of the display session";
            };

            restart = lib.mkOption {
              type = lib.types.enum [ "never" "on-failure" ];
              default = "never";
              description = "Restart policy if the service exits unexpectedly";
            };
          };
        }
      );
      default = { };
      description = "Compositor-agnostic services bound to the display session lifetime";
    };

    startCommand = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Command provided by the active backend to start and supervise the display session";
    };
  };

  config = {
    local.displaySession.exportedVariables = [
      "GSETTINGS_BACKEND"
      "WAYLAND_DISPLAY"
      "XDG_CURRENT_DESKTOP"
    ];

    assertions = [
      {
        assertion = enabledServices == { } || cfg.backend != "none";
        message = "displaySession: services are enabled (${lib.concatStringsSep ", " (lib.attrNames enabledServices)}), but local.displaySession.backend is 'none'";
      }
      {
        assertion = cfg.backend == "none" || cfg.startCommand != null;
        message = "displaySession: backend '${cfg.backend}' did not set local.displaySession.startCommand";
      }
      {
        assertion = restartingServices == { } || cfg.supportedFeatures.restart;
        message = "displaySession: services request restart (${lib.concatStringsSep ", " (lib.attrNames restartingServices)}), but backend '${cfg.backend}' does not support restart";
      }
    ];
  };
}
