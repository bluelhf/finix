{ pkgs, lib, ... }:

{
  users.groups.plugdev = { };

  services.udev.packages = lib.singleton (
    pkgs.writeTextFile {
      name = "bladerf-udev-rules";
      text = ''
        SUBSYSTEM=="usb", ATTR{idVendor}=="2cf0", ATTR{idProduct}=="5246", MODE="0660", GROUP="plugdev"
        SUBSYSTEM=="usb", ATTR{idVendor}=="2cf0", ATTR{idProduct}=="5250", MODE="0660", GROUP="plugdev"
        SUBSYSTEM=="usb", ATTR{idVendor}=="1d50", ATTR{idProduct}=="6066", MODE="0660", GROUP="plugdev"
      '';
      destination = "/etc/udev/rules.d/88-bladerf.rules";
    }
  );
}
