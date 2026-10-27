# host-specific hardware config
{ pkgs, ... }:

{
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [ "video=Virtual-1:1920x1080" ];
  hardware.firmware = [ pkgs.linux-firmware ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/2233432d-f05d-4383-b009-30ad4b2ddb54";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/AD93-0D98";
    fsType = "vfat";
    options = [ "fmask=0077" "dmask=0077" ];
  };

  swapDevices = [ ];
}
