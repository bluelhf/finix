{ config, ... }:

{
  imports = [
    ./identities.nix
    ../secrets.nix
  ];

  local.secrets.files.wifi-eduroam.file = ../../secrets/wifi-eduroam.age;

  local.network.wifi.eduroam = {
    ssid = "eduroam";
    autoconnect = true;
    priority = 100;
    security.eap = {
      method = "peap";
      phase2Auth = "mschapv2";
      identity = config.local.wifi.identities.eduroam;
      caCert = ./harica-tls-ecc-root-2021.pem;
      domainMatch = "radius.org.aalto.fi";
      passwordSecret = "wifi-eduroam";
    };
  };
}
