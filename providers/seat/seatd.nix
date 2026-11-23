{ config, lib, modules, ... }:

let
  cfg = config.local.seat;
in
{
  imports = [ modules.sessiond-uaccess ];

  options.local.seat.backend = lib.mkOption {
    type = lib.types.enum [ "seatd" ];
  };

  config = lib.mkMerge [
    {
      local.seat.backend = lib.mkDefault "seatd";
    }

    (lib.mkIf (cfg.backend == "seatd") {
      local.seat.supportedFeatures.uaccess = true;
      local.grants.groups.seat = [ "seat" ];

      local.capabilities = {
        required = [
          "session-manager"
          "device-manager"
        ];
        providers.seatd = {
          enable = true;
          provides = [ "seat-manager" ];
        };
      };

      services.seatd.enable = true;
      services.sessiond-uaccess.enable = true;
    })
  ];
}
