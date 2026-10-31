{
  imports = [ ../../profiles/wifi/identities.nix ];

  local.wifi.identities = {
    eduroam = "ilari.suhonen@aalto.fi";
    aalto = "ilari.suhonen@aalto.fi";
  };
}
