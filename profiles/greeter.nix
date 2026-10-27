{ lib, pkgs, modules, ... }:

{
  imports = [ modules.greetd ];

  services.greetd = {
    enable = true;
    settings.default_session.command = "${lib.getExe pkgs.tuigreet}";
  };
}
