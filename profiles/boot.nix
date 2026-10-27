{ lib, pkgs, modules, ... }:

{
  imports = [ modules.limine ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  programs.limine = {
    enable = true;
    settings.editor_enabled = lib.mkDefault true; # woah scary !!
  };
}
