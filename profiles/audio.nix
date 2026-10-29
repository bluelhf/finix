{ modules, ... }:

{
  imports = with modules; [
    pipewire
    wireplumber
    rtkit
  ];

  programs = {
    pipewire = {
      enable = true;
      alsa.enable = true;
    };
    wireplumber.enable = true;
  };

  services.rtkit.enable = true;
}
