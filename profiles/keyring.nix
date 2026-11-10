{ lib, pkgs, modules, ... }:

let
  pam = "${pkgs.gnome-keyring}/lib/security/pam_gnome_keyring.so";
in
{
  imports = [ modules.gnome-keyring ];

  programs.gnome-keyring.enable = true;

  security.pam.services.greetd.text = lib.mkMerge [
    (lib.mkBefore "auth optional ${pam}")
    (lib.mkAfter "session optional ${pam} auto_start\n")
  ];
}
