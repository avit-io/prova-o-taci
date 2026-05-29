{
  description = "Verified Functional Programming in Agda – studio personale";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    ial = {
      url = "github:cedille/ial";
      flake = false;
    };
  };

  outputs =
    { nixpkgs, ial, ... }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      devShells = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
          hp = pkgs.haskell.lib;

          cornelis-src = pkgs.fetchFromGitHub {
            owner = "agda";
            repo = "cornelis";
            rev = "8401538b8d5056571827679658331136c38f11be";
            sha256 = "sha256-Z/2hBW/bRb8wtJqBUT8tqgoXg4XqGNvp8L6xw+zHDaU=";
          };

          cornelis = (hp.doJailbreak (pkgs.haskellPackages.callCabal2nix "cornelis" cornelis-src { })).overrideAttrs (_: {
            doCheck = false;
          });

          agda-wrapped = pkgs.writeShellScriptBin "agda" ''
            [ -z "$AGDA_DIR" ] && AGDA_DIR="$PWD/.agda-local-work"
            exec ${pkgs.agda}/bin/agda --library-file="$AGDA_DIR/libraries" "$@"
          '';
        in
        {
          default = pkgs.mkShell {
            buildInputs = [
              agda-wrapped
              cornelis
              pkgs.zlib
              pkgs.libffi
              pkgs.ncurses
              pkgs.texlive.combined.scheme-full
              pkgs.ghostscript
              pkgs.python3
              pkgs.perl
            ];

            shellHook = ''
              mkdir -p .agda-local-work
              export AGDA_DIR="$PWD/.agda-local-work"

              if [ ! -d "$AGDA_DIR/ial" ]; then
                cp -r ${ial}/. "$AGDA_DIR/ial/"
                chmod -R u+w "$AGDA_DIR/ial"
              fi

              AGDA_LIB_FILE=$(find "$AGDA_DIR/ial" -maxdepth 1 -name "*.agda-lib" | head -1)
              LIB_NAME=$(grep "^name:" "$AGDA_LIB_FILE" | awk '{print $2}')

              echo "$AGDA_LIB_FILE" > "$AGDA_DIR/libraries"
              echo "$LIB_NAME" > "$AGDA_DIR/defaults"
            '';
          };
        });
    };
}
