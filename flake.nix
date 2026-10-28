{
  description = "Ilari's Finix config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    finix.url = "github:finix-community/finix";
    community-modules.url = "github:finix-community/community-modules";
  };

  outputs =
    inputs@{ self, nixpkgs, finix, ... }:
    let
      mkHost =
        { dir, system }:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        finix.lib.finixSystem {
          inherit (pkgs) lib;

          specialArgs = {
            inherit inputs;
            modulesPath = "${nixpkgs}/nixos/modules";
          };

          modules = [
            { nixpkgs.pkgs = pkgs; }
            ./contract/system.nix
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
      };
    };
}
