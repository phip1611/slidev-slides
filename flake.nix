{
  description = "My Slidev slides";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    { self, ... }@inputs:
    let
      systems = inputs.nixpkgs.lib.systems.flakeExposed;
      forAllSystems =
        function:
        inputs.nixpkgs.lib.genAttrs systems (system: function inputs.nixpkgs.legacyPackages.${system});

      # All slides (sub projects) with their pnpm dep hash for Nix.
      projectDefs = [
        {
          dir = "2025-10-10-eurorust-minimal-rust-kernel";
          depHash = "sha256-3983U/zwu7FpLTlhs+9fWKBGi0PtEGxPewRvAZQKiCw=";
        }
      ];
    in
    {
      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          inputsFrom = [
            self.packages.${pkgs.system}.runInstallAllScript
          ];
          packages = with pkgs; [
            nodejs
            pnpm
          ];
          # Runs "pnpm" install in each package
          shellHook = ''
            echo "You may:"
            echo "- run \`$ npm run dev\` in an individual project to get started"
            echo "- run \`$ nix run .#runInstallAllScript\` to install all pnpm dependencies"
          '';
        };
      });

      formatter = forAllSystems (pkgs: pkgs.nixfmt-tree);

      packages = forAllSystems (
        pkgs:
        let
          lib = pkgs.lib;
          baseSrc = lib.fileset.toSource {
            root = ./.;
            fileset = lib.fileset.gitTracked ./.;
          };
          combinedSlides = pkgs.symlinkJoin {
            name = "all-slides";
            paths =
              let
                buildProjectDef =
                  { dir, depHash }:
                  pkgs.callPackage ./nix/build.nix {
                    inherit depHash;
                    pname = dir;
                    src = "${baseSrc}/${dir}";
                  };
              in
              map buildProjectDef projectDefs;
          };
        in
        {
          default = combinedSlides;
          runInstallAllScript = pkgs.writeShellScriptBin "run-install-all" ''
            echo "Running `pnpm install` on each package ..."
            find . -maxdepth 2 -name package.json -type f -print0 |
              while IFS= read -r -d "" pkg; do
                dir=$(dirname "$pkg")
                echo ">>> Installing in $dir"
                (cd "$dir" && pnpm install)
              done
          '';
        }
      );
    };
}
