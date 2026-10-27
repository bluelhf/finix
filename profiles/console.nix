{ config, lib, modules, ... }:

{
  imports = [ modules.getty ];
  services.getty.enable = true;
  hardware.console.keyMap = lib.mkDefault config.local.keyboardLayout;
}
