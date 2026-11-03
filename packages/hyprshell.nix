{ hyprshell }:

# hyprland 0.57 replaced numeric workspace ids with addresses, which breaks
# hyprshell 4.10.x; drop this once nixpkgs ships a release that supports it
#
# fast-alt-tab: hyprland 0.57 never delivers the alt release binds, so the
# switcher only closed on esc; close it from the window instead
hyprshell.overrideAttrs (old: {
  patches = (old.patches or [ ]) ++ [
    ../patches/hyprshell-hyprland-0.57-compat.patch
    ../patches/hyprshell-fast-alt-tab.patch
  ];
})
