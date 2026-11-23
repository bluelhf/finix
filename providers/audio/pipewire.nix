{ config, lib, pkgs, modules, ... }:

let
  cfg = config.local.audio;
  wpctl = "${config.programs.wireplumber.package}/bin/wpctl";
in
{
  imports = with modules; [
    pipewire
    wireplumber
    rtkit
  ];

  options.local.audio.backend = lib.mkOption {
    type = lib.types.enum [ "pipewire" ];
  };

  config = lib.mkMerge [
    {
      local.audio.backend = lib.mkDefault "pipewire";
    }

    (lib.mkIf (cfg.backend == "pipewire") {
      local.audio = {
        supportedFeatures.volumeControl = true;
        commands = {
          raiseVolume = "${wpctl} set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+";
          lowerVolume = "${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 5%-";
          toggleMute = "${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle";
          toggleMicMute = "${wpctl} set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
          mixer = lib.mkDefault (lib.getExe pkgs.pavucontrol);
        };
      };

      programs = {
        pipewire = {
          enable = true;
          alsa.enable = true;
        };
        wireplumber.enable = true;
      };

      services.rtkit.enable = true;

      local.loginSession.services = {
        pipewire = {
          enable = true;
          command = lib.getExe' config.programs.pipewire.package "pipewire";
          restart = "on-failure";
          restartDelay = 5;
        };
        wireplumber = {
          enable = true;
          command = lib.getExe' config.programs.wireplumber.package "wireplumber";
          restart = "on-failure";
          restartDelay = 5;
        };
        pipewire-pulse = {
          enable = true;
          command = lib.getExe' config.programs.pipewire.package "pipewire-pulse";
          restart = "on-failure";
          restartDelay = 5;
        };
      };
    })
  ];
}
