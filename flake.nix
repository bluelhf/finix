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
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };

      mkHost =
        hostDir:
        finix.lib.finixSystem {
          inherit (pkgs) lib;

          specialArgs = {
            inherit inputs;
            modulesPath = "${nixpkgs}/nixos/modules";
          };

          modules = [
            { nixpkgs.pkgs = pkgs; }
            ./contract/system.nix
            hostDir
          ];
        };
    in
    {
      nixosConfigurations.qemulaattori = mkHost ./hosts/qemulaattori;
    };
}
