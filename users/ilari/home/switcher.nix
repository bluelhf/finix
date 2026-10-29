{ pkgs, ... }:

let
  toml = pkgs.formats.toml { };
in
{
  home.packages = [ pkgs.hyprshell ];

  # alt + tab window switcher; defaults to alt + tab on the current monitor
  xdg.configFile."hyprshell/config.toml".source = toml.generate "hyprshell-config.toml" {
    version = 4;
    windows.switch = { };
  };
}
