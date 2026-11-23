{ config, ... }:

{
  imports = [
    # hardware
    ./hardware.nix
    ../../hardware/qemu-guest.nix

    # host profile
    ../../profiles/base.nix
    ../../profiles/nix.nix
    ../../profiles/boot.nix
    ../../providers/privilege/sudo.nix
    ../../providers/secrets/age.nix
    ../../providers/network/networkmanager.nix
    ../../profiles/console.nix
    ../../profiles/fonts.nix
    ../../providers/seat/seatd.nix
    ../../profiles/desktop.nix
    ../../profiles/theme.nix
    ../../profiles/greeter.nix
    ../../profiles/keyring.nix
    ../../profiles/tools.nix

    # users
    ../../users/ilari/account.nix
  ];

  networking.hostName = "qemulaattori";
  time.timeZone = "Europe/Helsinki";
  local.keyboardLayout = "fi";

  local.grants.users.ilari = [
    "admin"
    "graphics"
    "seat"
    "input"
    "network"
  ];
}
