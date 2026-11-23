{ config, lib, ... }:

let
  cfg = config.local.audio;
  cmds = cfg.commands;
in
{
  options.local.audio = {
    backend = lib.mkOption {
      type = lib.types.enum [ "none" ];
      default = "none";
      description = "Selected backend implementing the audio role";
    };

    supportedFeatures = {
      volumeControl = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether the selected backend provides volume and mute control commands";
      };
    };

    commands = {
      raiseVolume = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Command to raise default output sink volume";
      };

      lowerVolume = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Command to lower default output sink volume";
      };

      toggleMute = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Command to toggle default output sink mute";
      };

      toggleMicMute = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Command to toggle default input source mute";
      };

      mixer = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Interactive audio mixer command";
      };
    };
  };

  config.assertions = [
    {
      assertion =
        !cfg.supportedFeatures.volumeControl
        || (
          cmds.raiseVolume != null
          && cmds.lowerVolume != null
          && cmds.toggleMute != null
          && cmds.toggleMicMute != null
        );
      message = "audio: backend '${cfg.backend}' claims volumeControl support but did not populate all volume/mute commands";
    }
  ];
}
