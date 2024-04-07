{
  description = "basic cpp development shell";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nixpkgs-stable.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
  };

  outputs = { nixpkgs, flake-utils, pre-commit-hooks, self, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        inherit (pkgs) callPackage;

        common = callPackage ./nix/common.nix { inherit system; };
      in {

        checks.pre-commit-check = callPackage ./nix/checks.nix {
          inherit pkgs pre-commit-hooks system;
        };

        formatter = pkgs.nixfmt;

        devShells =
          import ./nix/shells.nix { inherit pkgs common self system; };
      });
}
