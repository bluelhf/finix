{ config, lib, ... }:

let
  cfg = config.local.power;
in
{
  options.local.power = {
    backend = lib.mkOption {
      type = lib.types.enum [ "none" ];
      default = "none";
      description = "Selected backend implementing power and suspend handling";
    };

    sleepMode = lib.mkOption {
      type = lib.types.enum [ "s2idle" "deep" ];
      default = "deep";
      description = "Kernel memory sleep state for suspend";
    };

    powerButtonAction = lib.mkOption {
      type = lib.types.enum [ "ignore" "suspend" ];
      default = "suspend";
      description = "Action taken when the physical power button is pressed";
    };

    suspendCommand = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Command provided by the active backend to suspend the machine to RAM";
    };
  };

  config.assertions = [
    {
      assertion = cfg.backend == "none" || cfg.suspendCommand != null;
      message = "power: backend '${cfg.backend}' did not set local.power.suspendCommand";
    }
  ];
}
