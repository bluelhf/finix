{ config, lib, pkgs, osConfig, ... }:

let
  waybar = pkgs.callPackage ../../../packages/waybar.nix { };

  audioCmds = lib.attrByPath [ "local" "audio" "commands" ] { } osConfig;

  commands = {
    "@launcher@" = toString config.local.apps.launcher;
    "@brightnessctl@" = lib.getExe pkgs.brightnessctl;
    "@blueman-manager@" = lib.getExe' pkgs.blueman "blueman-manager";
    "@rfkill@" = lib.getExe' pkgs.util-linux "rfkill";
    "@audio-mixer@" = toString (audioCmds.mixer or "");
    "@audio-toggle-mute@" = toString (audioCmds.toggleMute or "");
    "@nm-connection-editor@" = lib.getExe' pkgs.networkmanagerapplet "nm-connection-editor";
    "@hyprctl@" = lib.getExe' osConfig.programs.hyprland.package "hyprctl";
  };
in
{
  home.packages = [ waybar ];

  xdg.configFile."waybar/config.jsonc".text =
    lib.replaceStrings (lib.attrNames commands) (lib.attrValues commands)
      (builtins.readFile ./waybar/config.jsonc);
  xdg.configFile."waybar/style.css".source = ./waybar/style.css;

  local.displaySession.services.waybar = {
    enable = lib.mkDefault true;
    command = lib.getExe waybar;
  };

  local.capabilities = {
    exclusive = [ "status-bar" ];
    providers.waybar = {
      enable = config.local.displaySession.services.waybar.enable;
      provides = [ "status-bar" ];
    };
  };
}
