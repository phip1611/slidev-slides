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
      # Structure:
      # - `src`       : Nix path to source
      # - `depHash`   : pnpm dependency hash
      # - `meta.slug` : URL friendly short-name
      # - `meta.title`: Title of the talk
      projectDefs = [
        {
          src = ./2025-10-10-eurorust-minimal-rust-kernel;
          depHash = "sha256-3983U/zwu7FpLTlhs+9fWKBGi0PtEGxPewRvAZQKiCw=";
          meta = {
            slug = "eurorust-2025";
            title = "A Minimal Rust Kernel - Printing to QEMU with core::fmt";
          };
        }
        {
          src = ./2025-10-cyberus-combine-demo;
          depHash = "sha256-gYRqj036MSUw+Uag9+fwXwW64gcy9gw51BCW/gxNHjI=";
          meta = {
            slug = "cyberus-combine-2025-10";
            title = "Slidev demo for Cyberus Combine";
          };
        }
      ];

      # Builds a single slidev project.
      buildProject =
        pkgs:
        {
          src,
          depHash,
          meta,
        }:
        pkgs.callPackage ./nix/build.nix {
          inherit depHash meta;
          # Limit the files to what is actually relevant.
          src = pkgs.lib.fileset.toSource {
            root = src;
            fileset = pkgs.lib.fileset.gitTracked src;
          };
          pname = meta.slug;
        };
    in
    {
      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          inputsFrom = builtins.attrValues self.packages.${pkgs.system};
          packages = with pkgs; [
            nodejs
            pnpm
          ];
          shellHook = ''
            echo "You may:"
            echo "- run \`$ nix run .#runInstallAllScript\` to install pnpm dependencies in all projects"
            echo "- run \`$ pnpm run dev\` in an *individual project* to get started (pnpm, not npm!)"
          '';
        };
      });

      formatter = forAllSystems (pkgs: pkgs.nixfmt-tree);

      packages = forAllSystems (
        pkgs:
        let
          lib = pkgs.lib;
          buildProject' = buildProject pkgs;

          # Generates an attribute set for all provided talks (slidev projects)
          # in a `slug => drv` format. Each talk contains its files in flat
          # form, i.e., without the dir.
          allTalksAttrs = lib.listToAttrs (
            map (def: {
              name = "talk-${def.meta.slug}";
              value = buildProject' def;
            }) projectDefs
          );

          # Combined derivation where each talk is in a subdirectory.
          allTalksCombinedDrv = pkgs.symlinkJoin {
            name = "slides-combined";
            paths = map (
              drv:
              pkgs.runCommand "${drv.name}-in-dir" { } ''
                mkdir -p $out
                ln -s ${drv} $out/${drv.meta.slug}
              ''
            ) (lib.attrValues allTalksAttrs);
          };

          runInstallAllScript = pkgs.writeShellScriptBin "run-install-all" ''
            echo "Running `pnpm install` on each package ..."
            find . -maxdepth 2 -name package.json -type f -print0 |
              while IFS= read -r -d "" pkg; do
                dir=$(dirname "$pkg")
                echo ">>> Installing in $dir"
                (cd "$dir" && pnpm install)
              done
          '';
        in
        (
          {
            combined = allTalksCombinedDrv;
            default = allTalksCombinedDrv;
          }
          // allTalksAttrs
        )
      );
    };
}
