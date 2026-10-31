{ lib, ... }:

{
  options.local.wifi.identities = lib.mkOption {
    type = with lib.types; attrsOf str;
    default = { };
    example.eduroam = "username@aalto.fi";
    description = "EAP identity per wifi profile name";
  };
}
