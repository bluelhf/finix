{ config, lib, modules, ... }:

let
  cfg = config.local.power;
in
{
  imports = with modules; [
    tlp
    acpid
    zzz
  ];

  options.local.power.backend = lib.mkOption {
    type = lib.types.enum [ "zzz" ];
  };

  config = lib.mkMerge [
    {
      local.power.backend = lib.mkDefault "zzz";
    }

    (lib.mkIf (cfg.backend == "zzz") {
      programs.zzz.enable = true;

      local.power.suspendCommand = "${lib.getExe config.programs.zzz.package} -z";

      services.tlp = {
        enable = true;
        settings = {
          MEM_SLEEP_ON_AC = lib.mkDefault cfg.sleepMode;
          MEM_SLEEP_ON_BAT = lib.mkDefault cfg.sleepMode;
        };
      };

      services.acpid = lib.mkIf (cfg.powerButtonAction == "suspend") {
        enable = true;
        handlers.power-button = {
          event = "button/power.*";
          action = cfg.suspendCommand;
        };
      };
    })
  ];
}
