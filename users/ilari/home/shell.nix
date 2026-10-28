{ pkgs, ... }:

{
  programs.fish = {
    package = pkgs.fish;

    enable = true;

    interactiveShellInit = ''
      fish_config theme choose catppuccin-mocha
      set -g fish_greeting
    '';
  };

  xdg.configFile."fish/functions/fish_prompt.fish".source = ./fish_prompt.fish;
}
