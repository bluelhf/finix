{ lib, ... }:

{
  options.local = {
    apps = {
      browser = lib.mkOption {
        type = with lib.types; nullOr str;
        default = null;
        example = "firefox";
        description = "web browser command";
      };

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

    compositor = {
      exitCommand = lib.mkOption {
        type = with lib.types; nullOr str;
        default = null;
        description = "Command to cleanly exit the active compositor session";
      };
    };
  };
}
