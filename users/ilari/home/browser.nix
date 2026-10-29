{ config, pkgs, ... }:

{
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-devedition;
    configPath = "${config.xdg.configHome}/mozilla/firefox";
  };
}
