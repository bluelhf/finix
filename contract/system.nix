{ lib, ... }:

{
  options.local = {
    keyboardLayout = lib.mkOption {
      type = lib.types.str;
      default = "fi";
      example = "us";
      description = "XKB layout of the keyboard for this host";
    };

    display.softwareCursor = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "true if the host's display doesn't have a hardware cursor";
    };
  };
}
