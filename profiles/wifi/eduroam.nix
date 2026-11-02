{ config, pkgs, ... }:

let
  ini = pkgs.formats.ini { };
in
{
  imports = [
    ./identities.nix
    ../secrets.nix
  ];

  local.secrets.files.wifi-eduroam.file = ../../secrets/wifi-eduroam.age;

  local.secrets.templates.eduroam = {
    path = "/run/NetworkManager/system-connections/eduroam.nmconnection";
    replace."@password@" = "wifi-eduroam";
    source = ini.generate "eduroam.nmconnection" {
      connection = {
        id = "eduroam";
        type = "wifi";
        autoconnect = true;
        autoconnect-priority = 100;
      };
      wifi.ssid = "eduroam";
      wifi-security.key-mgmt = "wpa-eap";
      "802-1x" = {
        eap = "peap;";
        identity = config.local.wifi.identities.eduroam;
        ca-cert = "${./harica-tls-ecc-root-2021.pem}";
        domain-match = "radius.org.aalto.fi";
        phase2-auth = "mschapv2";
        password = "@password@";
      };
      ipv4.method = "auto";
      ipv6.method = "auto";
    };
  };
}
