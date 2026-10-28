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
}
