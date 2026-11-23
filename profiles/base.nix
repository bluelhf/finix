{ config, modules, ... }:

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
    udev.enable = true;
    sessiond.enable = true;
  };

  local.capabilities = {
    exclusive = [
      "device-manager"
      "session-manager"
    ];
    providers = {
      udev = {
        enable = config.services.udev.enable;
        provides = [ "device-manager" ];
      };
      sessiond = {
        enable = config.services.sessiond.enable;
        provides = [ "session-manager" ];
      };
    };
  };
}
