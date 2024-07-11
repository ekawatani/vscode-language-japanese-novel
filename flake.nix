{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        buildNodeJs = "${nixpkgs}/pkgs/development/web/nodejs/nodejs.nix";

        overlay = (final: prev: rec {
          # 1. Change the version of the node here if necessary, e.g. `prev.nodejs_18`.
          # nodejs = prev.nodejs_latest;

          # 2. If you need a specific node js version, then follow this pattern.
          #    To get the sha256 hash, specify an empty string and try to build. Then, it'll output the hash for you.
          # nodejs = (prev.callPackage buildNodeJs { python = pkgs.python3; }) {
          #   enableNpm = true;
          #   version = "20.14.0";
          #   sha256 = "sha256-CGVQKPDYQ26IFj+RhgRNY10/Nqhe5Sjza9BbbF5Gwbs=";
          # };

          # pnpm = prev.nodePackages.pnpm;

          # 3. Follow this pattern below if you want a package to depend on the modified
          # yarn = (prev.yarn.override { inherit nodejs; });
        });

        pkgs = import nixpkgs {
          inherit system;
          # overlays = [ overlay ];
        };
      in
      {
        # For devbox usage.
        packages = {
          nodejs = pkgs.nodejs;
          pnpm = pkgs.pnpm;
        };

        devShells.default = pkgs.mkShell
          {
            packages = with pkgs; [
              nodejs
              vsce
            ];
          };
      });
}
