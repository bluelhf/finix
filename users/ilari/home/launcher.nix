{ config, lib, ... }:

{
  programs.fuzzel = {
    enable = true;
    settings.colors = {
      background = "1e1e2ee6";
      text = "cdd6f4ff";
      match = "f38ba8ff";
      selection = "585b70ff";
      selection-text = "cdd6f4ff";
      selection-match = "f38ba8ff";
      counter = "7f849cff";
      border = "b4befeff";
    };
  };

  local.apps.launcher = lib.getExe config.programs.fuzzel.package;
}
