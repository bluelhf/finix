{ lib, ... }:

{
  options.local.apps = {
    terminal = lib.mkOption {
      type = with lib.types; nullOr str;
      default = null;
      example = "x-terminal-emulator";
      description = "terminal emulator command";
    };

    launcher = lib.mkOption {
      type = with lib.types; nullOr str;
      default = null;
      example = "fuzzel";
      description = "application launcher command";
    };

    screenshot = lib.mkOption {
      type = with lib.types; nullOr str;
      default = null;
      example = "screenshot";
      description = "screenshot command, takes `screen` or `region` as its argument";
    };
  };
}
