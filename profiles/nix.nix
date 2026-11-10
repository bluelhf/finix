{ modules, ... }:

{
  imports = [ modules.nix-daemon ];

  services.nix-daemon = {
    enable = true;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
        "ca-derivations"
        "dynamic-derivations"
        "recursive-nix"
      ];
      trusted-users = [
        "root"
        "@wheel"
      ];
    };
  };
}
