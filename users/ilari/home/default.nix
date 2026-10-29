{ ... }:

{
  imports = [
    ../../../contract/home.nix

    ./shell.nix
    ./terminal.nix
    ./browser.nix
    ./chat.nix
    ./dev
    ./hyprland.nix
    ./launcher.nix
    ./screenshot.nix
    ./switcher.nix
    ./nix-tools.nix
  ];

  home.username = "ilari";
  home.homeDirectory = "/home/ilari";
  home.stateVersion = "24.11";

  xdg.enable = true;
}
