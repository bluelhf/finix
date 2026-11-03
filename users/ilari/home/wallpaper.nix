{ pkgs, lib, ... }:

let
  wallpaper = ./wallpapers/kodama.jpg;
in
{
  home.packages = [ pkgs.swaybg ];

  local.apps.wallpaper = "${lib.getExe pkgs.swaybg} -i ${wallpaper} -m fill";
}
