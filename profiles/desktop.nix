{ config, lib, pkgs, modules, ... }:

{
  imports = [ modules.hyprland ];

  programs.hyprland.enable = true;
  hardware.graphics.enable = true;

  xdg.portal = {
    enable = true;
    portals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
  };

  xdg.icons.enable = true;
  environment.pathsToLink = [ "/share/applications" ];

  # not used by hyprland but nice to have
  environment.variables = {
    NIX_XDG_DESKTOP_PORTAL_DIR = "/run/current-system/sw/share/xdg-desktop-portal/portals";
  }
  //
  lib.mkIf config.local.display.softwareCursor {
    WLR_NO_HARDWARE_CURSORS = "1";
  };
}
