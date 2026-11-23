{ config, lib, pkgs, modules, ... }:

let
  cfg = config.local.networkmanager;
  ini = pkgs.formats.ini { };

  concatPluginAttrs = attr: lib.concatMap (plugin: plugin.${attr} or [ ]) cfg.plugins;
  pluginRuntimeDeps = concatPluginAttrs "networkManagerRuntimeDeps";
  pluginDbusDeps = concatPluginAttrs "networkManagerDbusDeps";

  pluginType = lib.types.package // {
    description = "NetworkManager plugin package";
    check =
      p:
      lib.assertMsg
        (lib.types.package.check p && p ? networkManagerPlugin && lib.isString p.networkManagerPlugin)
        ''
          Package '${p.name}' is not a NetworkManager plugin.
          Those need to have a 'networkManagerPlugin' attribute.
        '';
  };

  pluginEtc = builtins.listToAttrs (
    map (pkg: {
      name = "NetworkManager/${pkg.networkManagerPlugin}";
      value.source = "${pkg}/lib/NetworkManager/${pkg.networkManagerPlugin}";
    }) cfg.plugins
  );

  profileEtc = lib.mapAttrs' (
    name: sections:
    lib.nameValuePair "NetworkManager/system-connections/${name}.nmconnection" {
      mode = "0600";
      source = ini.generate "${name}.nmconnection" sections;
    }
  ) cfg.profiles;

  etcEntries = pluginEtc // profileEtc;
in
{
  imports = with modules; [
    networkmanager
  ];

  options.local.networkmanager = {
    plugins = lib.mkOption {
      type = lib.types.listOf pluginType;
      default = [ ];
      example = lib.literalExpression "[ pkgs.networkmanager-openconnect ]";
      description = "NetworkManager VPN plugin packages to install and register";
    };

    profiles = lib.mkOption {
      type = lib.types.attrsOf ini.type;
      default = { };
      description = "Declarative NetworkManager connection profiles without secrets";
    };
  };

  config = lib.mkMerge [
    {
      services.networkmanager.enable = lib.mkDefault true;

      assertions = [
        {
          assertion =
            (cfg.plugins == [ ] && cfg.profiles == { })
            || config.services.networkmanager.enable;
          message = "local.networkmanager.plugins and local.networkmanager.profiles require services.networkmanager.enable = true";
        }
      ];
    }

    (lib.mkIf config.services.networkmanager.enable {
      services.networkmanager.settings.logging.backend = lib.mkDefault "syslog";

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

      environment.systemPackages = cfg.plugins ++ pluginRuntimeDeps;
      services.dbus.packages = cfg.plugins ++ pluginDbusDeps;
      environment.etc = etcEntries;

      finit.services.network-manager = {
        reload-signal = "none";
        reload-triggers = map (e: e.source) (lib.attrValues etcEntries);
      };
    })
  ];
}
