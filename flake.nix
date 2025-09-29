{
  description = "My Slidev slides";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    { self, ... }@inputs:
    let
      systems = inputs.nixpkgs.lib.systems.flakeExposed;

      # Generates the typical per-system flake attributes.
      forAllSystems =
        function:
        inputs.nixpkgs.lib.genAttrs systems (system: function inputs.nixpkgs.legacyPackages.${system});
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
            echo "- run \`$ runInstallAllScript\` to install all pnpm dependencies"
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
          projectDefs = [
            {
              dir = "2025-11-xx-jug-saxony-uefi-os-loader";
              hash = "sha256-xZUETOy25U7YvLCyJcz5PNnpS7m4mf2lFGFUOcCSsWA=";
            }
          ];
          combinedSlides = pkgs.symlinkJoin {
            name = "all-slides";
            paths =
              let
                buildProjectDef =
                  { dir, hash }:
                  pkgs.callPackage ./nix/build.nix {
                    inherit hash;
                    pname = dir;
                    src = "${baseSrc}/${dir}";
                  };
              in
              map buildProjectDef projectDefs;
          };
        in
        {
          default = combinedSlides;
          runInstallAllScript = pkgs.writeShellScriptBin "run-pnpm-install-on-all-projects" ''
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
