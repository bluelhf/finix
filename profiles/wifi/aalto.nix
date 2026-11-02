{ config, pkgs, ... }:

let
  ini = pkgs.formats.ini { };
in
{
  imports = [
    ./identities.nix
    ../secrets.nix
  ];

  local.secrets.files.wifi-aalto.file = ../../secrets/wifi-aalto.age;

  local.secrets.templates.aalto = {
    path = "/run/NetworkManager/system-connections/aalto.nmconnection";
    replace."@password@" = "wifi-aalto";
    source = ini.generate "aalto.nmconnection" {
      connection = {
        id = "aalto";
        type = "wifi";
        autoconnect = true;
        autoconnect-priority = 150;
      };
      wifi.ssid = "aalto";
      wifi-security.key-mgmt = "wpa-eap";
      "802-1x" = {
        eap = "peap;";
        identity = config.local.wifi.identities.aalto;
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
