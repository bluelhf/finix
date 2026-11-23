{ config, lib, pkgs, modules, ... }:

let
  cfg = config.local.boot;
in
{
  imports = [ modules.limine ];

  options.local.boot.backend = lib.mkOption {
    type = lib.types.enum [ "limine" ];
  };

  config = lib.mkMerge [
    {
      local.boot.backend = lib.mkDefault "limine";
    }

    (lib.mkIf (cfg.backend == "limine") {
      local.boot.supportedFeatures.menuEditToggle = true;

      boot.kernelPackages = pkgs.linuxPackages_latest;

      programs.limine = {
        enable = true;
        settings.editor_enabled = cfg.allowMenuEdit;
      };
    })
  ];
}
