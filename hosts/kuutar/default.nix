{
  imports = [
    # hardware
    ./hardware.nix
    ../../hardware/intel-nvme.nix

    # providers
    ../../providers/boot/limine.nix
    ../../providers/privilege/sudo.nix
    ../../providers/secrets/age.nix
    ../../providers/network/networkmanager.nix
    ../../providers/login-session/sessiond-hooks.nix
    ../../providers/audio/pipewire.nix
    ../../providers/seat/seatd.nix
    ../../providers/power/zzz.nix
    ../../providers/greeter/greetd.nix

    # host profile
    ../../profiles/base.nix
    ../../profiles/nix.nix
    ../../profiles/wifi/eduroam.nix
    ../../profiles/wifi/aalto.nix
    ../../profiles/vpn/aalto.nix
    ../../profiles/bluetooth.nix
    ../../profiles/console.nix
    ../../profiles/fonts.nix
    ../../profiles/desktop.nix
    ../../profiles/theme.nix
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
