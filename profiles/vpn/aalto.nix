{
  local.network.vpn.aalto-vpn = {
    displayName = "Aalto VPN";
    autoconnect = false;
    protocol.anyconnect = {
      gateway = "vpn1.aalto.fi";
      userAgent = "AnyConnect";
      interactiveAuth = true;
    };
  };
}
