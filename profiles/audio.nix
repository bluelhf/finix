{ config, lib, modules, ... }:

let
  restart = {
    on = "Failure";
    delay = 5;
  };
in
{
  imports = with modules; [
    pipewire
    wireplumber
    rtkit
    sessiond-hooks
  ];

  programs = {
    pipewire = {
      enable = true;
      alsa.enable = true;
    };
    wireplumber.enable = true;
  };

  services.rtkit.enable = true;

  services.sessiond-hooks = {
    enable = true;
    hooks = {
      pipewire.settings = {
        on_start = lib.getExe' config.programs.pipewire.package "pipewire";
        inherit restart;
      };
      wireplumber.settings = {
        on_start = lib.getExe' config.programs.wireplumber.package "wireplumber";
        inherit restart;
      };
      pipewire-pulse.settings = {
        on_start = lib.getExe' config.programs.pipewire.package "pipewire-pulse";
        inherit restart;
      };
    };
  };
}
