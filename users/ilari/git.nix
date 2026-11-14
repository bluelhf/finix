{ config, ... }:

{
  imports = [ ./home/dev/git-identity.nix ];

  local.git.identity = {
    name = "Ilari Suhonen";
    email = "ilari.suhonen@gmail.com";
    signingKey = "${config.home.homeDirectory}/.ssh/id_ed25519";
  };
}
