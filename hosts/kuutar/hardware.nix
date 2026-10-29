# host-specific hardware config
{ pkgs, ... }:

{
  boot.loader.efi.canTouchEfiVariables = true;

  hardware.firmware = [ pkgs.linux-firmware ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/0896db02-9e6f-44a1-bf45-c0a634ee7a2e";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/D9FD-8FC6";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };
}
