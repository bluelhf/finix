{
  imports = [
    # hardware
    ./hardware.nix
    ../../hardware/qemu-guest.nix

    # providers
    ../../providers/boot/limine.nix
    ../../providers/privilege/sudo.nix
    ../../providers/secrets/age.nix
    ../../providers/network/networkmanager.nix
    ../../providers/seat/seatd.nix
    ../../providers/greeter/greetd.nix

    # host profile
    ../../profiles/base.nix
    ../../profiles/nix.nix
    ../../profiles/console.nix
    ../../profiles/fonts.nix
    ../../profiles/desktop.nix
    ../../profiles/theme.nix
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
