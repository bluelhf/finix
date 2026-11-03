{ hyprshell }:

# hyprland 0.57 replaced numeric workspace ids with addresses, which breaks
# hyprshell 4.10.x; drop this once nixpkgs ships a release that supports it
hyprshell.overrideAttrs (old: {
  patches = (old.patches or [ ]) ++ [ ../patches/hyprshell-hyprland-0.57-compat.patch ];
})
