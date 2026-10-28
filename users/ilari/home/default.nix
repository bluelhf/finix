{ ... }:

{
  imports = [
    ../../../contract/home.nix

    ./shell.nix
    ./terminal.nix
    ./browser.nix
    ./hyprland.nix
    ./launcher.nix
    ./nix-tools.nix
  ];

  home.username = "ilari";
  home.homeDirectory = "/home/ilari";
  home.stateVersion = "24.11";

  xdg.enable = true;
}
