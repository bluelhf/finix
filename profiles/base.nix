{ modules, pkgs, ... }:

{
  imports = with modules; [
    sysklogd
    sudo
    polkit
    bash
  ];

  finit.runlevel = 3;

  programs = {
    sudo.enable = true;
    bash.enable = true;
  };

  services = {
    sysklogd.enable = true;
    polkit.enable = true;
    dbus.enable = true;
    udev = {
      enable = true;
      # fix for https://github.com/finix-community/finix/blob/d18bad0bc20827cdac09c5152366498d1f1dbc41/modules/services/udev/default.nix#L142 hardcoding pkgs.udev and not cfg.package
      packages = [ pkgs.eudev ];
    };
    sessiond.enable = true;
  };
}
