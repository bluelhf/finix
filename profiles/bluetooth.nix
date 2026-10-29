{ modules, ... }:

{
  imports = [ modules.bluetooth ];

  services.bluetooth.enable = true;
}
