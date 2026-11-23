{ config, lib, pkgs, ... }:

let
  cfg = config.local.secrets;
  age = "${pkgs.age}/bin/age";

  decrypt = _: secret: ''
    ${age} -d -i ${lib.escapeShellArg cfg.identity} -o ${lib.escapeShellArg secret.path} ${secret.file}
  '';

  render = _: template: ''
    mkdir -p ${dirOf template.path}
    content=$(cat ${template.source})
    ${lib.concatStringsSep "\n" (
      lib.mapAttrsToList (placeholder: name: ''
        secret=$(cat ${cfg.files.${name}.path})
        content="''${content//${placeholder}/"$secret"}"
      '') template.replace
    )}
    printf '%s\n' "$content" > ${template.path}
  '';
in
{
  options.local.secrets.backend = lib.mkOption {
    type = lib.types.enum [ "age" ];
  };

  config = lib.mkMerge [
    {
      local.secrets.backend = lib.mkDefault "age";
    }

    (lib.mkIf (cfg.backend == "age") {
      local.secrets = {
        supportedFeatures.templates = true;
        identity = lib.mkDefault "/var/lib/secrets/key.txt";
      };

      assertions = [
        {
          assertion = cfg.files == { } || cfg.identity != null;
          message = "secrets(age): local.secrets.files is non-empty, but local.secrets.identity is null";
        }
      ];

      system.activation.scripts = {
        secrets = {
          deps = [ "specialfs" ];
          text = ''
            (
              umask 077
              mkdir -p /run/secrets
              ${lib.concatMapAttrsStringSep "" decrypt cfg.files}
              ${lib.concatMapAttrsStringSep "" render cfg.templates}
            )
          '';
        };

        # passwordFile is read while creating the users
        users.deps = [ "secrets" ];
      };
    })
  ];
}
