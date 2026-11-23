{ config, lib, ... }:

let
  cfg = config.local.network;
  wifiValues = lib.attrValues cfg.wifi;
  vpnValues = lib.attrValues cfg.vpn;

  hasWifiOpen = lib.any (w: w.security ? open) wifiValues;
  hasWifiPsk = lib.any (w: w.security ? psk) wifiValues;
  hasWifiEap = lib.any (w: w.security ? eap) wifiValues;
  hasVpnAnyconnect = lib.any (v: v.protocol ? anyconnect) vpnValues;

  wifiSecurityType = lib.types.attrTag {
    open = lib.mkOption {
      type = lib.types.submodule { };
      description = "Unencrypted open Wi-Fi network";
    };

    psk = lib.mkOption {
      type = lib.types.submodule {
        options.passwordSecret = lib.mkOption {
          type = lib.types.str;
          description = "Name of the secret in local.secrets.files holding the passphrase";
        };
      };
      description = "WPA-PSK personal Wi-Fi network";
    };

    eap = lib.mkOption {
      type = lib.types.submodule {
        options = {
          method = lib.mkOption {
            type = lib.types.enum [ "peap" "ttls" ];
            description = "Outer EAP method";
          };

          phase2Auth = lib.mkOption {
            type = lib.types.enum [ "mschapv2" "pap" ];
            description = "Inner phase-2 authentication method";
          };

          identity = lib.mkOption {
            type = lib.types.str;
            description = "EAP user identity";
          };

          caCert = lib.mkOption {
            type = lib.types.path;
            description = "CA certificate validating the RADIUS server";
          };

          domainMatch = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = "Expected RADIUS server certificate domain";
          };

          passwordSecret = lib.mkOption {
            type = lib.types.str;
            description = "Name of the secret in local.secrets.files holding the EAP password";
          };
        };
      };
      description = "802.1X enterprise Wi-Fi network";
    };
  };

  vpnProtocolType = lib.types.attrTag {
    anyconnect = lib.mkOption {
      type = lib.types.submodule {
        options = {
          gateway = lib.mkOption {
            type = lib.types.str;
            description = "VPN gateway hostname or address";
          };

          userAgent = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = "Client User-Agent string presented to the gateway";
          };

          interactiveAuth = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Whether authentication requires an interactive session prompt";
          };
        };
      };
      description = "Cisco AnyConnect / OpenConnect VPN";
    };
  };
in
{
  options.local.network = {
    backend = lib.mkOption {
      type = lib.types.enum [ "none" ];
      default = "none";
      description = "Selected backend implementing the network profile contract";
    };

    supportedFeatures = {
      wifiOpen = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether the selected backend supports open Wi-Fi profiles";
      };

      wifiPsk = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether the selected backend supports WPA-PSK Wi-Fi profiles";
      };

      wifiEap = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether the selected backend supports 802.1X EAP Wi-Fi profiles";
      };

      vpnAnyconnect = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether the selected backend supports AnyConnect VPN profiles";
      };
    };

    wifi = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            ssid = lib.mkOption {
              type = lib.types.str;
              description = "Wi-Fi network SSID";
            };

            autoconnect = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Whether to connect automatically when in range";
            };

            priority = lib.mkOption {
              type = lib.types.nullOr lib.types.int;
              default = null;
              description = "Autoconnect priority; higher values are preferred";
            };

            security = lib.mkOption {
              type = wifiSecurityType;
              description = "Wi-Fi security scheme and credentials";
            };
          };
        }
      );
      default = { };
      description = "Declarative Wi-Fi network profiles";
    };

    vpn = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule (
          { name, ... }:
          {
            options = {
              displayName = lib.mkOption {
                type = lib.types.str;
                default = name;
                description = "Human-readable name for the VPN connection";
              };

              autoconnect = lib.mkOption {
                type = lib.types.bool;
                default = false;
                description = "Whether to connect automatically";
              };

              protocol = lib.mkOption {
                type = vpnProtocolType;
                description = "VPN protocol and endpoint configuration";
              };
            };
          }
        )
      );
      default = { };
      description = "Declarative VPN connection profiles";
    };
  };

  config.assertions = [
    {
      assertion = (cfg.wifi == { } && cfg.vpn == { }) || cfg.backend != "none";
      message = "network: profiles are declared, but local.network.backend is 'none'";
    }
    {
      assertion = !hasWifiOpen || cfg.supportedFeatures.wifiOpen;
      message = "network: open Wi-Fi profiles are declared, but backend '${cfg.backend}' does not support wifiOpen";
    }
    {
      assertion = !hasWifiPsk || cfg.supportedFeatures.wifiPsk;
      message = "network: WPA-PSK Wi-Fi profiles are declared, but backend '${cfg.backend}' does not support wifiPsk";
    }
    {
      assertion = !hasWifiEap || cfg.supportedFeatures.wifiEap;
      message = "network: 802.1X EAP Wi-Fi profiles are declared, but backend '${cfg.backend}' does not support wifiEap";
    }
    {
      assertion = !hasVpnAnyconnect || cfg.supportedFeatures.vpnAnyconnect;
      message = "network: AnyConnect VPN profiles are declared, but backend '${cfg.backend}' does not support vpnAnyconnect";
    }
  ];
}
