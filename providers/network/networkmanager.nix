{ config, lib, pkgs, modules, ... }:

let
  cfg = config.local.network;
  ini = pkgs.formats.ini { };

  vpnValues = lib.attrValues cfg.vpn;
  hasAnyconnect = lib.any (v: v.protocol ? anyconnect) vpnValues;
  hasInteractiveVpn = lib.any (
    v: (v.protocol ? anyconnect) && v.protocol.anyconnect.interactiveAuth
  ) vpnValues;

  plugins = lib.optional hasAnyconnect pkgs.networkmanager-openconnect;

  concatPluginAttrs = attr: lib.concatMap (plugin: plugin.${attr} or [ ]) plugins;
  pluginRuntimeDeps = concatPluginAttrs "networkManagerRuntimeDeps";
  pluginDbusDeps = concatPluginAttrs "networkManagerDbusDeps";

  pluginEtc = builtins.listToAttrs (
    map (pkg: {
      name = "NetworkManager/${pkg.networkManagerPlugin}";
      value.source = "${pkg}/lib/NetworkManager/${pkg.networkManagerPlugin}";
    }) plugins
  );

  renderWifiIni =
    name: w:
    {
      connection = {
        id = name;
        type = "wifi";
        inherit (w) autoconnect;
      }
      // lib.optionalAttrs (w.priority != null) {
        autoconnect-priority = w.priority;
      };
      wifi.ssid = w.ssid;
      ipv4.method = "auto";
      ipv6.method = "auto";
    }
    // lib.optionalAttrs (w.security ? psk) {
      wifi-security = {
        key-mgmt = "wpa-psk";
        psk = "@password@";
      };
    }
    // lib.optionalAttrs (w.security ? eap) {
      wifi-security.key-mgmt = "wpa-eap";
      "802-1x" = {
        eap = "${w.security.eap.method};";
        inherit (w.security.eap) identity;
        ca-cert = "${w.security.eap.caCert}";
        phase2-auth = w.security.eap.phase2Auth;
        password = "@password@";
      }
      // lib.optionalAttrs (w.security.eap.domainMatch != null) {
        domain-match = w.security.eap.domainMatch;
      };
    };

  renderVpnIni =
    _: v:
    let
      ac = v.protocol.anyconnect;
    in
    {
      connection = {
        id = v.displayName;
        type = "vpn";
        inherit (v) autoconnect;
      };
      vpn = {
        inherit (ac) gateway;
        protocol = "anyconnect";
        service-type = "org.freedesktop.NetworkManager.openconnect";
      }
      // lib.optionalAttrs (ac.userAgent != null) {
        useragent = ac.userAgent;
      }
      // lib.optionalAttrs ac.interactiveAuth {
        cookie-flags = 2;
      };
      vpn-secrets = {
        inherit (ac) gateway;
        gwcert = "";
      };
    };

  openWifiProfiles = lib.filterAttrs (_: w: w.security ? open) cfg.wifi;
  secretWifiProfiles = lib.filterAttrs (_: w: !(w.security ? open)) cfg.wifi;

  openWifiEtc = lib.mapAttrs' (
    name: w:
    lib.nameValuePair "NetworkManager/system-connections/${name}.nmconnection" {
      mode = "0600";
      source = ini.generate "${name}.nmconnection" (renderWifiIni name w);
    }
  ) openWifiProfiles;

  vpnEtc = lib.mapAttrs' (
    name: v:
    lib.nameValuePair "NetworkManager/system-connections/${name}.nmconnection" {
      mode = "0600";
      source = ini.generate "${name}.nmconnection" (renderVpnIni name v);
    }
  ) cfg.vpn;

  secretWifiTemplates = lib.mapAttrs (
    name: w:
    let
      secretName =
        if w.security ? eap then w.security.eap.passwordSecret else w.security.psk.passwordSecret;
    in
    {
      path = "/run/NetworkManager/system-connections/${name}.nmconnection";
      replace."@password@" = secretName;
      source = ini.generate "${name}.nmconnection" (renderWifiIni name w);
    }
  ) secretWifiProfiles;

  etcEntries = pluginEtc // openWifiEtc // vpnEtc;
in
{
  imports = [
    modules.networkmanager
  ];

  options.local.network.backend = lib.mkOption {
    type = lib.types.enum [ "networkmanager" ];
  };

  config = lib.mkMerge [
    {
      local.network.backend = lib.mkDefault "networkmanager";
    }

    (lib.mkIf (cfg.backend == "networkmanager") {
      local.network.supportedFeatures = {
        wifiOpen = true;
        wifiPsk = true;
        wifiEap = true;
        vpnAnyconnect = true;
      };

      local.grants.groups.network = [ "networkmanager" ];

      services.networkmanager = {
        enable = lib.mkDefault true;
        settings.logging.backend = lib.mkDefault "syslog";
      };

      local.privilege.polkitRules.networkmanager = {
        group = "networkmanager";
        actionPrefix = "org.freedesktop.NetworkManager.";
      };

      users.groups.nm-openconnect = lib.mkIf hasAnyconnect { };
      users.users.nm-openconnect = lib.mkIf hasAnyconnect {
        isSystemUser = true;
        group = "nm-openconnect";
      };

      local.session.requiredCapabilities = lib.optional hasInteractiveVpn "nm-secret-agent";
      local.secrets.templates = secretWifiTemplates;

      environment.systemPackages = plugins ++ pluginRuntimeDeps;
      services.dbus.packages = plugins ++ pluginDbusDeps;
      environment.etc = etcEntries;

      finit.services.network-manager = {
        reload-signal = "none";
        reload-triggers = map (e: e.source) (lib.attrValues etcEntries);
      };
    })
  ];
}
