{ config, lib, ... }:

{
  programs.fuzzel.enable = true;

  local.apps.launcher = lib.getExe config.programs.fuzzel.package;
}
