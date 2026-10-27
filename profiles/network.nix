{ modules, ... }:

{
  imports = with modules; [
    dhcpcd
    iwd
  ];

  services = {
    dhcpcd.enable = true;
    iwd.enable = true;
  };
}
