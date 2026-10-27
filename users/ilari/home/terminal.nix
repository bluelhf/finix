{ config, lib, ... }:

{
  programs.alacritty = {
    enable = true;
    settings.window.opacity = 0.9;
  };

  local.apps.terminal = lib.getExe config.programs.alacritty.package;
}
