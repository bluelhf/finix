{ config, lib, pkgs, ... }:

let
  cfg = config.local.displaySession;
  enabledServices = lib.filterAttrs (_: svc: svc.enable) cfg.services;
  exportedVars = lib.escapeShellArgs (lib.unique cfg.exportedVariables);

  launchService =
    _: svc:
    if svc.restart == "on-failure" then
      ''
        (
          child=""
          trap 'if [ -n "$child" ]; then kill "$child" 2>/dev/null || true; wait "$child" 2>/dev/null || true; fi; exit 0' TERM INT
          while true; do
            ${svc.command} &
            child=$!
            wait "$child"
            status=$?
            child=""
            [ "$status" -eq 0 ] && exit 0
            ${pkgs.coreutils}/bin/sleep 2 &
            child=$!
            wait "$child"
            child=""
          done
        ) &
        pids+=($!)
      ''
    else
      ''
        ${svc.command} &
        pids+=($!)
      '';

  runner = pkgs.writeShellScriptBin "display-session" ''
    set -u

    ${lib.optionalString (cfg.exportedVariables != [ ]) ''
      ${pkgs.dbus}/bin/dbus-update-activation-environment ${exportedVars}
    ''}

    pids=()
    waiter_pid=""
    cleanup() {
      if [ -n "$waiter_pid" ]; then
        kill "$waiter_pid" 2>/dev/null || true
      fi
      for pid in "''${pids[@]}"; do
        kill "$pid" 2>/dev/null || true
      done
      wait 2>/dev/null || true
    }
    trap 'exit 0' INT TERM
    trap cleanup EXIT

    ${lib.concatStringsSep "\n" (lib.mapAttrsToList launchService enabledServices)}

    sock=""
    if [ -n "''${WAYLAND_DISPLAY:-}" ]; then
      case "$WAYLAND_DISPLAY" in
        /*) sock="$WAYLAND_DISPLAY" ;;
        *)  [ -n "''${XDG_RUNTIME_DIR:-}" ] && sock="$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY" ;;
      esac
    fi

    if [ -n "$sock" ]; then
      lock="$sock.lock"
      if [ -e "$lock" ]; then
        ${pkgs.util-linux}/bin/flock --shared "$lock" ${pkgs.coreutils}/bin/true &
        waiter_pid=$!
        wait "$waiter_pid"
        waiter_pid=""
      else
        while [ -S "$sock" ]; do
          ${pkgs.coreutils}/bin/sleep 2 &
          waiter_pid=$!
          wait "$waiter_pid"
          waiter_pid=""
        done
      fi
    else
      wait
    fi
  '';
in
{
  options.local.displaySession.backend = lib.mkOption {
    type = lib.types.enum [ "flock" ];
  };

  config = lib.mkMerge [
    {
      local.displaySession.backend = lib.mkDefault "flock";
    }

    (lib.mkIf (cfg.backend == "flock") {
      local.displaySession = {
        supportedFeatures.restart = true;
        startCommand = lib.getExe runner;
      };
    })
  ];
}
