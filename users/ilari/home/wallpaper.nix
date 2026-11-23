{ config, pkgs, lib, ... }:

let
  wallpaper = ./wallpapers/kodama.jpg;
in
{
  home.packages = [ pkgs.swaybg ];

  local.displaySession.services.swaybg = {
    enable = lib.mkDefault true;
    command = "${lib.getExe pkgs.swaybg} -i ${wallpaper} -m fill";
  };

  local.capabilities = {
    exclusive = [ "wallpaper" ];
    providers.swaybg = {
      enable = config.local.displaySession.services.swaybg.enable;
      provides = [ "wallpaper" ];
    };
  };
}
