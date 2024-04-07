{
  description = "rust development shell [RustAudio]";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
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

  nixConfig = {
    extra-substituters = "https://nix-community.cachix.org";
    extra-trusted-public-keys =
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";

  };

  outputs = { nixpkgs, fenix, flake-utils, pre-commit-hooks, self, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            (_: prev: {
              rustPlatform =
                let inherit (fenix.packages.${system}.minimal) toolchain;
                in prev.makeRustPlatform {
                  cargo = toolchain;
                  rustc = toolchain;
                };
            })
          ];
        };

        inherit (pkgs) callPackage;

        common = callPackage ./nix/common.nix { inherit system; };
      in {

        checks.pre-commit-check = callPackage ./nix/checks.nix {
          inherit pkgs pre-commit-hooks system;
        };

        formatter = pkgs.nixfmt;

        devShells =
          callPackage ./nix/shells.nix { inherit common self system; };
      });
}
