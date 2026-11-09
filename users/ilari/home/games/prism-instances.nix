{ config, lib, pkgs, ... }:

let
  cfg = config.local.prism.instances;

  root = "${config.xdg.dataHome}/PrismLauncher/instances";

  instanceCfg =
    inst:
    pkgs.writeText "instance.cfg" (
      lib.concatStringsSep "\n" (
        [
          "[General]"
          "ConfigVersion=1.3"
          "InstanceType=OneSix"
          "name=${inst.displayName}"
          "iconKey=default"
        ]
        ++ lib.optionals (inst.java != null) [
          "OverrideJavaLocation=true"
          "JavaPath=${inst.java}/lib/openjdk/bin/java"
        ]
      )
      + "\n"
    );
in
{
  options.local.prism.instances = lib.mkOption {
    default = { };
    description = "declarative prism launcher instances";
    type = lib.types.attrsOf (
      lib.types.submodule (
        { name, ... }:
        {
          options = {
            displayName = lib.mkOption {
              type = lib.types.str;
              default = name;
              description = "name shown in prism";
            };

            java = lib.mkOption {
              type = lib.types.nullOr lib.types.package;
              default = null;
              description = "jdk the instance runs on, prism picks one itself when null";
            };

            src = lib.mkOption {
              type = lib.types.str;
              description = ''
                instance tree: mmc-pack.json, links/ (read only files symlinked
                into the minecraft directory) and overrides/ (copied once,
                existing files are kept)
              '';
            };
          };
        }
      )
    );
  };

  config.home.activation = lib.mapAttrs' (
    id: inst:
    let
      dir = "${root}/${id}";
    in
    lib.nameValuePair "prismInstance-${id}" (
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        run mkdir -p "${dir}/minecraft"

        run install -m644 ${inst.src}/mmc-pack.json "${dir}/mmc-pack.json"

        if [ ! -e "${dir}/instance.cfg" ]; then
          run install -m644 ${instanceCfg inst} "${dir}/instance.cfg"
        fi

        run cp -rn --no-preserve=mode ${inst.src}/overrides/. "${dir}/minecraft/" || true

        run find "${dir}/minecraft" -type l -lname '/nix/store/*' -delete
        run cp -rs --no-preserve=mode ${inst.src}/links/. "${dir}/minecraft/"
        run install -m644 ${pkgs.writeText "allowed_symlinks.txt" "[prefix]/nix/store/\n"} "${dir}/minecraft/allowed_symlinks.txt"
      ''
    )
  ) cfg;
}
