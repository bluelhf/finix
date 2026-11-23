{ config, lib, ... }:

let
  cfg = config.local.greeter;
  hasPamHooks = cfg.pamAuthBefore != "" || cfg.pamSessionAfter != "";
in
{
  options.local.greeter = {
    backend = lib.mkOption {
      type = lib.types.enum [ "none" ];
      default = "none";
      description = "Selected backend implementing the login greeter role";
    };

    pamService = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "PAM service name exposed by the active greeter backend";
    };

    pamAuthBefore = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = "PAM auth directives prepended to the active greeter's PAM service";
    };

    pamSessionAfter = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = "PAM session directives appended to the active greeter's PAM service";
    };
  };

  config.assertions = [
    {
      assertion = !hasPamHooks || cfg.backend != "none";
      message = "greeter: PAM hooks are configured, but local.greeter.backend is 'none'";
    }
    {
      assertion = cfg.backend == "none" || cfg.pamService != null;
      message = "greeter: backend '${cfg.backend}' did not set local.greeter.pamService";
    }
  ];
}
