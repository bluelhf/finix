{ config, pkgs, modules, inputs, ... }:

{
  imports = [
    modules.fish
    inputs.community-modules.nixosModules.home-manager
    ./wifi.nix
    ../../profiles/secrets.nix
  ];

  programs.fish.enable = true;

  local.secrets.files.ilari-password.file = ../../secrets/ilari-password.age;

  users.users.ilari = {
    isNormalUser = true;
    shell = pkgs.fish;
    passwordFile = config.local.secrets.files.ilari-password.path;
    packages = [ ];
  };

  home-manager.users.ilari.imports = [ ./home inputs.nix-index-database.homeModules.default ];
  home-manager.enableProfileInstall = false;
}
