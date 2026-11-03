{ pkgs, ... }:

{
  home.packages = with pkgs; [
    gnome-system-monitor
    adwaita-icon-theme
  ];

  dconf.enable = false;

  xdg.configFile."glib-2.0/settings/keyfile" = {
    force = true;
    text = ''
      [org/gnome/desktop/interface]
      color-scheme='prefer-dark'
      gtk-theme='Adwaita-dark'
    '';
  };

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
    gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = true;
    gtk4.theme = null;
  };

  qt = {
    enable = true;
    platformTheme.name = "adwaita";
    style.name = "adwaita-dark";
  };
}
