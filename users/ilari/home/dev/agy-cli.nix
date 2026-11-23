{ pkgs, ... }:

{
  home.packages = [
    (pkgs.callPackage ../../../../packages/agy-cli.nix { })
  ];
}
