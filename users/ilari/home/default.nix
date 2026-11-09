{ ... }:

{
  imports = [
    ../../../contract/home.nix

    ./shell.nix
    ./terminal.nix
    ./browser.nix
    ./chat.nix
    ./dev
    ./games
    ./hyprland.nix
    ./launcher.nix
    ./screenshot.nix
    ./switcher.nix
    ./theme.nix
    ./wallpaper.nix
    ./waybar.nix
    ./nix-tools.nix
  ];

  home.username = "ilari";
  home.homeDirectory = "/home/ilari";
  home.stateVersion = "24.11";

  xdg.enable = true;
}
