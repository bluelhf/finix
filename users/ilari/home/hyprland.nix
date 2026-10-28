{ config, lib, osConfig, ... }:

let
  terminal = config.local.apps.terminal;
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    systemd.enable = false; # no systemd user session on finix
    configType = "lua";

    settings = {
      "$mod" = "SUPER";

      monitor = lib.mkDefault [ ", preferred, auto, 1" ];

      input.kb_layout = osConfig.local.keyboardLayout;

      bind =
        lib.optional (terminal != null) "$mod, Return, exec, ${terminal}"
        ++ [
          "CTRL, D, killactive"
          "$mod SHIFT, E, exit"

          "$mod, left, movefocus, l"
          "$mod, right, movefocus, r"
          "$mod, up, movefocus, u"
          "$mod, down, movefocus, d"
        ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
    }
    // lib.optionalAttrs osConfig.local.display.softwareCursor {
      cursor.no_hardware_cursors = 1;
    };
  };
}
