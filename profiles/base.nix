{ modules, ... }:

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
    mdevd.enable = true;
  };
}
