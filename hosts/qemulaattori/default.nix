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
    ../../profiles/network.nix
    ../../profiles/console.nix
    ../../profiles/fonts.nix
    ../../profiles/desktop.nix
    ../../profiles/greeter.nix
    ../../profiles/tools.nix

    # users
    ../../users/ilari/account.nix
  ];

  networking.hostName = "qemulaattori";
  time.timeZone = "Europe/Helsinki";
  local.keyboardLayout = "fi";

  users.users.ilari.extraGroups = [
    "wheel"
    "video"
    "input"
  ];
}
