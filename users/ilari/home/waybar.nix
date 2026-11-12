{ config, lib, pkgs, osConfig, ... }:

let
  audio = lib.attrByPath [ "programs" "wireplumber" "enable" ] false osConfig;

  commands = {
    "@launcher@" = toString config.local.apps.launcher;
    "@brightnessctl@" = lib.getExe pkgs.brightnessctl;
    "@blueman-manager@" = lib.getExe' pkgs.blueman "blueman-manager";
    "@rfkill@" = lib.getExe' pkgs.util-linux "rfkill";
    "@pavucontrol@" = lib.getExe pkgs.pavucontrol;
    "@wpctl@" = lib.optionalString audio "${osConfig.programs.wireplumber.package}/bin/wpctl";
    "@nm-connection-editor@" = lib.getExe' pkgs.networkmanagerapplet "nm-connection-editor";
    "@hyprctl@" = lib.getExe' osConfig.programs.hyprland.package "hyprctl";
  };
in
{
  home.packages = [ pkgs.waybar ];

  xdg.configFile."waybar/config.jsonc".text =
    lib.replaceStrings (lib.attrNames commands) (lib.attrValues commands)
      (builtins.readFile ./waybar/config.jsonc);
  xdg.configFile."waybar/style.css".source = ./waybar/style.css;

  local.apps.bar = lib.getExe pkgs.waybar;
}
