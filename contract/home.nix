{ lib, ... }:

{
  options.local.apps.terminal = lib.mkOption {
    type = with lib.types; nullOr str;
    default = null;
    example = "x-terminal-emulator";
    description = "terminal emulator command";
  };

  options.local.apps.launcher = lib.mkOption {
    type = with lib.types; nullOr str;
    default = null;
    example = "fuzzel";
    description = "application launcher command";
  };

  options.local.apps.screenshot = lib.mkOption {
    type = with lib.types; nullOr str;
    default = null;
    example = "screenshot";
    description = "screenshot command, takes `screen` or `region` as its argument";
  };

  options.local.apps.bar = lib.mkOption {
    type = with lib.types; nullOr str;
    default = null;
    example = "waybar";
    description = "status bar command, started with the session and expected to keep running";
  };

  options.local.apps.wallpaper = lib.mkOption {
    type = with lib.types; nullOr str;
    default = null;
    example = "swaybg -i wallpaper.png";
    description = "wallpaper command, started with the session and expected to keep running";
  };
}
