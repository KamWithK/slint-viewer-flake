{
  inputs = {
    naersk.url = "github:nix-community/naersk/master";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      nixpkgs,
      utils,
      ...
    }:
    utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        defaultPackage =
          with pkgs;
          rustPlatform.buildRustPackage rec {
            pname = "slint-viewer";
            version = "1.8.0";

            src = fetchCrate {
              inherit pname version;
              hash = "sha256-3k1iHLsq7H/Q1t6OslSa/8Q0UvrCvDDCm1NTEgxmirs=";
            };
            cargoHash = "sha256-XF9UeRRpqGyEK9XIN7canw97xun7dDa0nlEAZY0C13k=";

            nativeBuildInputs = [
              pkg-config
              autoPatchelfHook
            ];
            buildInputs = [
              (lib.getLib stdenv.cc.cc)
            ];
            runtimeDependencies = [
              wayland
              libxkbcommon
              libGL
              libGL.dev
              xorg.libXcursor
              xorg.libXrandr
              xorg.libXi
              xorg.libX11
              fontconfig.lib
            ];
          };
      }
    );
}
