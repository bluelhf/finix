{ config, lib, ... }:

let
  cfg = config.local.secrets;

  missingTemplateSecrets = lib.concatLists (
    lib.mapAttrsToList (
      templateName: template:
      map (secretName: { inherit templateName secretName; }) (
        lib.filter (secretName: !(cfg.files ? ${secretName})) (
          lib.unique (lib.attrValues template.replace)
        )
      )
    ) cfg.templates
  );
in
{
  options.local.secrets = {
    backend = lib.mkOption {
      type = lib.types.enum [ "none" ];
      default = "none";
      description = "Selected backend implementing secrets decryption and templating";
    };

    supportedFeatures = {
      templates = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether the selected backend supports rendering secret templates";
      };
    };

    identity = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Path to the host decryption identity, provisioned out of band";
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
                  description = "Encrypted secret file";
                };

                path = lib.mkOption {
                  type = str;
                  default = "/run/secrets/${name}";
                  description = "Where the decrypted file is written on activation";
                };
              };
            }
          )
        );
      default = { };
      example.ilari-password.file = ../secrets/ilari-password.age;
      description = "Secrets decrypted on activation";
    };

    templates = lib.mkOption {
      type =
        with lib.types;
        attrsOf (
          submodule {
            options = {
              source = lib.mkOption {
                type = path;
                description = "File containing placeholders";
              };

              replace = lib.mkOption {
                type = attrsOf str;
                default = { };
                example."@password@" = "wifi-eduroam";
                description = "Mapping from placeholder to the name of the secret in local.secrets.files";
              };

              path = lib.mkOption {
                type = str;
                description = "Where the rendered file is written on activation";
              };
            };
          }
        );
      default = { };
      description = "Files with secrets substituted in on activation";
    };
  };

  config.assertions =
    [
      {
        assertion = (cfg.files == { } && cfg.templates == { }) || cfg.backend != "none";
        message = "secrets: files or templates are declared, but local.secrets.backend is 'none'";
      }
      {
        assertion = cfg.templates == { } || cfg.supportedFeatures.templates;
        message = "secrets: templates are declared, but backend '${cfg.backend}' does not support templates";
      }
    ]
    ++ map (
      { templateName, secretName }:
      {
        assertion = false;
        message = "secrets: template '${templateName}' references undefined secret '${secretName}'";
      }
    ) missingTemplateSecrets;
}
