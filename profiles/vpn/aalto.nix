# setup taken from https://github.com/langsjo/nixos-config/blob/main/modules/networking/nm-profiles/aalto-vpn.nix
# (originally from https://github.com/z10n-dev/nixos-anyconnect-webauth/blob/main/vpn.nix)
{ config, pkgs, ... }:

let
  gateway = "vpn1.aalto.fi";
in
{
  assertions = [
    {
      assertion = config.services.networkmanager.enable;
      message = "profiles/vpn/aalto.nix requires services.networkmanager.enable = true (import profiles/network.nix)";
    }
  ];

  users.groups.nm-openconnect = { };
  users.users.nm-openconnect = {
    isSystemUser = true;
    group = "nm-openconnect";
  };

  local.session.requiredCapabilities = [ "nm-secret-agent" ];

  local.networkmanager = {
    plugins = [ pkgs.networkmanager-openconnect ];

    profiles.aalto-vpn = {
      connection = {
        id = "Aalto VPN";
        type = "vpn";
        autoconnect = false;
      };
      vpn = {
        inherit gateway;
        useragent = "AnyConnect";
        cookie-flags = 2;
        protocol = "anyconnect";
        service-type = "org.freedesktop.NetworkManager.openconnect";
      };
      vpn-secrets = {
        inherit gateway;
        gwcert = "";
      };
    };
  };
}
