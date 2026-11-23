{
  description = "Ilari's Finix config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    finix.url = "github:finix-community/finix";
    community-modules.url = "github:finix-community/community-modules";
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ self, nixpkgs, finix, ... }:
    let
      mkHost =
        { dir, system }:
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfreePredicate =
              pkg:
              builtins.elem (nixpkgs.lib.getName pkg) [
                "intellij-idea"
                "webstorm"
                "rust-rover"
                "claude-code"
                "agy-cli"
              ];
          };
        in
        finix.lib.finixSystem {
          inherit (pkgs) lib;

          specialArgs = {
            inherit inputs;
            modulesPath = "${nixpkgs}/nixos/modules";
          };

          modules = [
            { nixpkgs.pkgs = pkgs; }
            ./contract/capabilities.nix
            ./contract/system.nix
            ./contract/grants.nix
            ./contract/secrets.nix
            ./contract/network.nix
            ./contract/login-session.nix
            ./contract/seat.nix
            ./contract/privilege.nix
            dir
          ];
        };
    in
    {
      nixosConfigurations = {
        qemulaattori = mkHost {
          dir = ./hosts/qemulaattori;
          system = "x86_64-linux";
        };
        kuutar = mkHost {
          dir = ./hosts/kuutar;
          system = "x86_64-linux";
        };
      };
    };
}
