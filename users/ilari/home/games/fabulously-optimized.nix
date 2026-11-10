{ pkgs, ... }:

{
  local.prism.instances.fabulously-optimized = {
    displayName = "Fabulously Optimized";
    src = pkgs.callPackage ../../../../packages/fabulously-optimized { };
    java = pkgs.jdk25;
    settings = {
      fullscreen = "true";
      fov = "1.0";
      mouseSensitivity = "0.7560504322320643";
      toggleSprint = "true";
      onboardAccessibility = "false";
    };
  };
}
