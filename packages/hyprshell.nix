{ hyprshell }:

hyprshell.overrideAttrs (old: {
  patches = (old.patches or [ ]) ++ [
    ../patches/hyprshell-fast-alt-tab.patch
  ];
})
