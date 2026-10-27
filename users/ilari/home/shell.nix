{ ... }:

{
  xdg.configFile = {
    "fish/functions/fish_prompt.fish".source = ./fish_prompt.fish;
    "fish/conf.d/theme.fish".text = ''
      if status is-interactive
        fish_config theme choose catppuccin-mocha
      end
    '';
    "fish/conf.d/greeting.fish".text = "set -g fish_greeting\n";
  };
}
