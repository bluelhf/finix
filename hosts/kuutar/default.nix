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
    ../../profiles/network.nix
    ../../profiles/bluetooth.nix
    ../../profiles/console.nix
    ../../profiles/fonts.nix
    ../../profiles/desktop.nix
    ../../profiles/greeter.nix
    ../../profiles/tools.nix

    # users
    ../../users/ilari/account.nix
  ];

  networking.hostName = "kuutar";
  time.timeZone = "Europe/Helsinki";
  local.keyboardLayout = "fi";

  users.users.ilari.extraGroups = [
    "wheel"
    "video"
    "input"
  ];
}
