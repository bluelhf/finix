{ lib, modules, ... }:

{
  imports = with modules; [
    networkmanager
  ];

  services.networkmanager = {
    enable = true;
    settings.logging.backend = lib.mkDefault "syslog";
  };
}
