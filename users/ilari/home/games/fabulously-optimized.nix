{ pkgs, ... }:

{
  local.prism.instances.fabulously-optimized = {
    displayName = "Fabulously Optimized";
    src = pkgs.callPackage ../../../../packages/fabulously-optimized { };
    java = pkgs.jdk25;
  };
}
