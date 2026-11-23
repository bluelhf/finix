{ config, ... }:

{
  local.secrets.files.wifi-aalto.file = ../../secrets/wifi-aalto.age;

  local.network.wifi.aalto = {
    ssid = "aalto";
    autoconnect = true;
    priority = 150;
    security.eap = {
      method = "peap";
      phase2Auth = "mschapv2";
      identity = config.local.network.identities.aalto;
      caCert = ./harica-tls-ecc-root-2021.pem;
      domainMatch = "radius.org.aalto.fi";
      passwordSecret = "wifi-aalto";
    };
  };
}
