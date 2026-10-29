{ pkgs, lib, ... }:

let
  screenshot = pkgs.writeShellApplication {
    name = "screenshot";
    runtimeInputs = with pkgs; [ grim slurp wl-clipboard ];
    text = ''
      case "''${1:-}" in
        screen)
          grim - | wl-copy --type image/png
          ;;
        region)
          geometry=$(slurp) || exit 0
          grim -g "$geometry" - | wl-copy --type image/png
          ;;
        *)
          echo "usage: screenshot screen|region" >&2
          exit 2
          ;;
      esac
    '';
  };
in
{
  home.packages = [ screenshot ];

  local.apps.screenshot = lib.getExe screenshot;
}
