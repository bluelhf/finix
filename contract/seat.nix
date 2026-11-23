{ config, lib, ... }:

let
  cfg = config.local.seat;
in
{
  options.local.seat = {
    backend = lib.mkOption {
      type = lib.types.enum [ "none" ];
      default = "none";
      description = "Selected backend implementing the seat management role";
    };

    supportedFeatures = {
      uaccess = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether the selected backend manages dynamic device ACLs (uaccess)";
      };
    };
  };

  config = {
    local.capabilities.exclusive = [ "seat-manager" ];

    assertions = [
      {
        assertion = cfg.backend == "none" || lib.elem "seat-manager" config.local.capabilities.provided;
        message = "seat: backend '${cfg.backend}' did not register the 'seat-manager' capability";
      }
    ];
  };
}
