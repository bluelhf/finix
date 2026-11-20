{ waybar }:

waybar.overrideAttrs (old: {
  postPatch = (old.postPatch or "") + ''
    substituteInPlace src/modules/battery.cpp \
      --replace-fail 'fmt::format("{:.3}", health)' 'health'
  '';
})
