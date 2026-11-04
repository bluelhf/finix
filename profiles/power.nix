{ config, lib, modules, ... }:

{
  imports = with modules; [
    tlp
    acpid
    zzz
  ];

  programs.zzz.enable = true;

  services.tlp = {
    settings = {
      INTEL_GPU_MIN_FREQ_ON_AC = 600;

      MEM_SLEEP_ON_AC = "deep";
      MEM_SLEEP_ON_BAT = "deep";
    };
  };

  services.acpid = {
    enable = true;
    handlers.power-button = {
      event = "button/power.*";
      action = "${lib.getExe config.programs.zzz.package} -z";
    };
  };
}
