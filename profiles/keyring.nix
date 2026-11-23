{ pkgs, modules, ... }:

let
  pam = "${pkgs.gnome-keyring}/lib/security/pam_gnome_keyring.so";
in
{
  imports = [ modules.gnome-keyring ];

  programs.gnome-keyring.enable = true;

  local.greeter = {
    pamAuthBefore = ''
      auth optional pam_unix.so likeauth nullok
      auth optional ${pam}
    '';
    pamSessionAfter = "session optional ${pam} auto_start";
  };
}
