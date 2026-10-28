{ config, lib, osConfig, ... }:

let
  terminal = config.local.apps.terminal;
  layout = builtins.toJSON osConfig.local.keyboardLayout;
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    systemd.enable = false; # no systemd user session on finix
    configType = "lua";

    extraConfig = ''
      local mod = "SUPER"

      hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })

      hl.config({
        input = { kb_layout = ${layout} },
        ${lib.optionalString osConfig.local.display.softwareCursor
          "cursor = { no_hardware_cursors = true },"}
      })

      ${lib.optionalString (terminal != null)
        ''hl.bind(mod .. " + RETURN", hl.dsp.exec_cmd(${builtins.toJSON terminal}))''}
      hl.bind("CTRL + D", hl.dsp.window.close())
      hl.bind(mod .. " + SHIFT + E", hl.dsp.exit())

      hl.bind(mod .. " + left",  hl.dsp.focus({ direction = "left" }))
      hl.bind(mod .. " + right", hl.dsp.focus({ direction = "right" }))
      hl.bind(mod .. " + up",    hl.dsp.focus({ direction = "up" }))
      hl.bind(mod .. " + down",  hl.dsp.focus({ direction = "down" }))

      hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
      hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
    '';
  };
}
