{ modules, ... }:

{
  imports = with modules; [
    networkmanager
  ];

  services.networkmanager.enable = true;
}
