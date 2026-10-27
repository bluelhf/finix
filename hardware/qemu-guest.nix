# qemu guest for now
{ modulesPath, ... }:

{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  boot = {
    initrd.availableKernelModules = [
      "ahci"
      "ata_piix"
      "xhci_pci"
      "virtio_pci"
      "floppy"
      "sr_mod"
      "virtio_blk"
      "usb_storage"
      "sd_mod"
    ];
    kernelModules = [ "virtio_gpu" ];
    kernelParams = [ "console=ttyS0,115200" ];
  };

  local.display.softwareCursor = true;
}
