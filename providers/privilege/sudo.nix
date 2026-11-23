{ config, lib, modules, ... }:

let
  cfg = config.local.privilege;
in
{
  imports = [ modules.sudo ];

  options.local.privilege.backend = lib.mkOption {
    type = lib.types.enum [ "sudo" ];
  };

  config = lib.mkMerge [
    {
      local.privilege.backend = lib.mkDefault "sudo";
    }

    (lib.mkIf (cfg.backend == "sudo") {
      programs.sudo.enable = true;
    })
  ];
}
