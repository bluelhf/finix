{ config, ... }:

{
  imports = [
    # hardware
    ./hardware.nix
    ../../hardware/intel-nvme.nix

    # host profile
    ../../profiles/base.nix
    ../../profiles/nix.nix
    ../../profiles/boot.nix
    ../../providers/privilege/sudo.nix
    ../../providers/secrets/age.nix
    ../../providers/network/networkmanager.nix
    ../../providers/login-session/sessiond-hooks.nix
    ../../profiles/wifi/eduroam.nix
    ../../profiles/wifi/aalto.nix
    ../../profiles/vpn/aalto.nix
    ../../profiles/bluetooth.nix
    ../../providers/audio/pipewire.nix
    ../../profiles/console.nix
    ../../profiles/fonts.nix
    ../../providers/seat/seatd.nix
    ../../profiles/desktop.nix
    ../../profiles/theme.nix
    ../../profiles/power.nix
    ../../profiles/greeter.nix
    ../../profiles/keyring.nix
    ../../profiles/tools.nix
    ../../profiles/sdr.nix

    # users
    ../../users/ilari/account.nix
  ];

  networking.hostName = "kuutar";
  time.timeZone = "Europe/Helsinki";
  local.keyboardLayout = "fi";

  local.grants.users.ilari = [
    "admin"
    "graphics"
    "seat"
    "input"
    "network"
    "sdr"
  ];
}
