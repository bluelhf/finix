{ config, lib, modules, ... }:

{
  imports = [ modules.hyprland ];

  programs.hyprland.enable = true;
  hardware.graphics.enable = true;
  services.seatd.enable = true;

  xdg.icons.enable = true;
  environment.pathsToLink = [ "/share/applications" ];

  # not used by hyprland but nice to have
  environment.variables = lib.mkIf config.local.display.softwareCursor {
    WLR_NO_HARDWARE_CURSORS = "1";
  };
}
