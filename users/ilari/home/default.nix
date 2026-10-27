{ ... }:

{
  imports = [
    ../../../contract/home.nix

    ./shell.nix
    ./terminal.nix
    ./browser.nix
    ./hyprland.nix
  ];

  home.username = "ilari";
  home.homeDirectory = "/home/ilari";
  home.stateVersion = "24.11";

  xdg.enable = true;
}
