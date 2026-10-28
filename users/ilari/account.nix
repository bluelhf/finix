{ pkgs, modules, inputs, ... }:

{
  imports = [
    modules.fish
    inputs.community-modules.nixosModules.home-manager
  ];

  programs.fish.enable = true;

  users.users.ilari = {
    isNormalUser = true;
    shell = pkgs.fish;
    passwordFile = "/etc/finix-passwords/ilari";
    packages = [ ];
  };

  home-manager.users.ilari.imports = [ ./home inputs.nix-index-database.homeModules.default ];
}
