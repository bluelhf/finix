{ pkgs, inputs, ... }:

{
  imports = [ inputs.community-modules.nixosModules.fastfetch ];

  programs.fastfetch.enable = true;

  environment.systemPackages = with pkgs; [
    nano curl wget
    git iputils iproute2
    nixos-rebuild-ng
  ];
}
