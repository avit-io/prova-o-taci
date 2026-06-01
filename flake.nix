{
  description = "Verified Functional Programming in Agda – studio personale";

  inputs = {
    piforge.url  = "github:avit-io/piforge";
    nixpkgs.follows = "piforge/nixpkgs";
    ial = {
      url   = "github:cedille/ial";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, piforge, ial, ... }:
    let
      systems       = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      devShells = forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in {
          default = piforge.lib.agda.mkShell {
            inherit pkgs;
            version             = "v27";
            useRuntimeLibraries = true;
            extraPackages       = piforge.lib.latex.packagesFor { inherit pkgs; };
            shellHook           = ''
              mkdir -p .agda-local-work
              export AGDA_DIR="$PWD/.agda-local-work"

              if [ ! -d "$AGDA_DIR/ial" ]; then
                cp -r ${ial}/. "$AGDA_DIR/ial/"
                chmod -R u+w "$AGDA_DIR/ial"
              fi

              AGDA_LIB_FILE=$(find "$AGDA_DIR/ial" -maxdepth 1 -name "*.agda-lib" | head -1)
              LIB_NAME=$(grep "^name:" "$AGDA_LIB_FILE" | awk '{print $2}')

              echo "$AGDA_LIB_FILE" > "$AGDA_DIR/libraries"
              echo "$LIB_NAME"      > "$AGDA_DIR/defaults"
            '';
          };
        });
    };
}
