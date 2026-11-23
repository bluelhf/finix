{ lib, modules, ... }:

{
  imports = with modules; [
    networkmanager
  ];

  services.networkmanager = {
    enable = true;
    settings.logging.backend = lib.mkDefault "syslog";
  };

  services.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (
        subject.isInGroup("networkmanager")
        && action.id.indexOf("org.freedesktop.NetworkManager.") == 0
      ) {
        return polkit.Result.YES;
      }
    });
  '';
}
