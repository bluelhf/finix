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
  options.local.secrets = {
    identity = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/secrets/key.txt";
      description = "age identity that decrypts the secrets, provisioned by hand";
    };

    files = lib.mkOption {
      type =
        with lib.types;
        attrsOf (
          submodule (
            { name, ... }:
            {
              options = {
                file = lib.mkOption {
                  type = path;
                  description = "age encrypted file";
                };

                path = lib.mkOption {
                  type = str;
                  default = "/run/secrets/${name}";
                  description = "where the decrypted file is written on activation";
                };
              };
            }
          )
        );
      default = { };
      example.ilari-password.file = ../secrets/ilari-password.age;
      description = "secrets decrypted on activation";
    };

    templates = lib.mkOption {
      type =
        with lib.types;
        attrsOf (submodule {
          options = {
            source = lib.mkOption {
              type = path;
              description = "file containing the placeholders";
            };

            replace = lib.mkOption {
              type = attrsOf str;
              default = { };
              example."@password@" = "wifi-eduroam";
              description = "placeholder to the name of the secret that replaces it";
            };

            path = lib.mkOption {
              type = str;
              description = "where the rendered file is written on activation";
            };
          };
        });
      default = { };
      description = "files with secrets substituted in on activation";
    };
  };

  config = {
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
  };
}
