{ config, lib, pkgs, ... }:

{
  local.displaySession.services.nm-applet = {
    enable = lib.mkDefault (lib.elem "nm-secret-agent" config.local.capabilities.required);
    command = "${lib.getExe pkgs.networkmanagerapplet} --indicator";
  };

  local.capabilities = {
    exclusive = [
      "nm-secret-agent"
      "network-tray"
    ];

    providers.nm-applet = {
      enable = config.local.displaySession.services.nm-applet.enable;
      provides = [
        "nm-secret-agent"
        "network-tray"
      ];
    };
  };
}
