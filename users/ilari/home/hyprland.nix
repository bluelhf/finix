{ config, lib, pkgs, osConfig, ... }:

let
  terminal = config.local.apps.terminal;
  launcher = config.local.apps.launcher;
  screenshot = config.local.apps.screenshot;
  layout = builtins.toJSON osConfig.local.keyboardLayout;
  audio = lib.attrByPath [ "programs" "wireplumber" "enable" ] false osConfig;
  wpctl = "${osConfig.programs.wireplumber.package}/bin/wpctl";
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

      hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1.5 })

      hl.config({
        input = { kb_layout = ${layout} },
        ${lib.optionalString osConfig.local.display.softwareCursor
          "cursor = { no_hardware_cursors = true },"}
      })

      ${lib.optionalString (terminal != null)
        ''hl.bind(mod .. " + RETURN", hl.dsp.exec_cmd(${builtins.toJSON terminal}))''}

      ${lib.optionalString (launcher != null)
        ''hl.bind(mod .. " + 7", hl.dsp.exec_cmd(${builtins.toJSON launcher}))''}

      ${lib.optionalString (screenshot != null) ''
        hl.bind("Print",       hl.dsp.exec_cmd(${builtins.toJSON "${screenshot} region"}))
        hl.bind("ALT + Print", hl.dsp.exec_cmd(${builtins.toJSON "${screenshot} screen"}))
      ''}

      hl.bind("ALT + F4", hl.dsp.window.close())
      hl.bind(mod .. " + SHIFT + E", hl.dsp.exit())

      hl.bind(mod .. " + left",  hl.dsp.focus({ direction = "left" }))
      hl.bind(mod .. " + right", hl.dsp.focus({ direction = "right" }))
      hl.bind(mod .. " + up",    hl.dsp.focus({ direction = "up" }))
      hl.bind(mod .. " + down",  hl.dsp.focus({ direction = "down" }))

      local TAGS = 10
      for i = 1, TAGS do
        hl.workspace_rule({ workspace = tostring(i), persistent = true })
        hl.bind("CTRL + ALT + " .. (i % 10), hl.dsp.focus({ workspace = tostring(i) }))
      end

      local function move_tag(step)
        return function()
          local ws = hl.get_active_workspace()
          if not ws then return end
          local target = (ws.id - 1 + step) % TAGS + 1
          hl.dispatch(hl.dsp.window.move({ workspace = target, follow = true }))
        end
      end

      hl.bind(mod .. " + SHIFT + right", move_tag(1))
      hl.bind(mod .. " + SHIFT + left",  move_tag(-1))

      hl.bind(mod .. " + SHIFT + space", hl.dsp.window.float({ action = "toggle" }))

      ${lib.optionalString audio ''
        hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(${builtins.toJSON "${wpctl} set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+"}), { locked = true, repeating = true })
        hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(${builtins.toJSON "${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 5%-"}), { locked = true, repeating = true })
        hl.bind("XF86AudioMute",        hl.dsp.exec_cmd(${builtins.toJSON "${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle"}), { locked = true })
        hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd(${builtins.toJSON "${wpctl} set-mute @DEFAULT_AUDIO_SOURCE@ toggle"}), { locked = true })
      ''}

      hl.on("hyprland.start", function()
        hl.exec_cmd("${pkgs.dbus}/bin/dbus-update-activation-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP HYPRLAND_INSTANCE_SIGNATURE")
        hl.exec_cmd("${lib.getExe (pkgs.callPackage ../../../packages/hyprshell.nix { })} run")
      end)

      hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
      hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
    '';
  };
}
