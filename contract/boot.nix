{ config, lib, ... }:

let
  cfg = config.local.boot;
in
{
  options.local.boot = {
    backend = lib.mkOption {
      type = lib.types.enum [ "none" ];
      default = "none";
      description = "Selected bootloader backend";
    };

    allowMenuEdit = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether the boot menu may be edited interactively at boot";
    };

    supportedFeatures = {
      menuEditToggle = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether the selected bootloader supports disabling interactive menu editing";
      };
    };
  };

  config.assertions = [
    {
      assertion = cfg.allowMenuEdit || cfg.supportedFeatures.menuEditToggle;
      message = "boot: local.boot.allowMenuEdit is false, but backend '${cfg.backend}' does not support menuEditToggle";
    }
  ];
}
