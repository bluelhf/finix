{ pkgs, ... }:

{
  # unfree so these have to be explicitly allowed in flake.nix
  home.packages = with pkgs; [
    intellij-idea
    webstorm
    rust-rover
  ];
}
