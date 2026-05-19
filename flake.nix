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
          depHash = "sha256-SRoSSyYsmcYjVhpT8wfty2v5qtd4fb7OR+Y/Ezq4U8M=";
          meta = {
            slug = "eurorust-2025";
            title = "A Minimal Rust Kernel - Printing to QEMU with core::fmt";
          };
        }
        {
          src = ./2025-10-cyberus-combine-demo;
          depHash = "sha256-Ckc+GmLpeDuuh2IZu8l2Cj9QOloTpNt5CSJ63UF9RUQ=";
          meta = {
            slug = "cyberus-combine-2025-10";
            title = "Slidev demo for Cyberus Combine";
          };
        }
        {
          src = ./2025-11-jug-saxony-writing-an-os-loader-in-rust;
          depHash = "sha256-Ckc+GmLpeDuuh2IZu8l2Cj9QOloTpNt5CSJ63UF9RUQ=";
          meta = {
            slug = "jug-saxony-loader-uefi-rs-2025-11";
            title = "Writing an OS-Loader in Rust with uefi-rs";
          };
        }
        {
          src = ./2026-03-cyberus-tech-talk-the-art-of-serial;
          depHash = "sha256-qLuC+ms0Sh0a6lCN4Jck0FjY4KphwFXYe7jitPWIimg=";
          meta = {
            slug = "cyberus-tech-talk-the-art-of-serial";
            title = "The (U)Art of Serial - A 16550 Deep Dive";
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
      devShells = forAllSystems (
        pkgs:
        let
          inherit (pkgs.stdenv.hostPlatform) system;
        in
        {
          default = pkgs.mkShell {
            inputsFrom = builtins.attrValues self.packages.${system};
            packages = with pkgs; [
              nodejs
              pnpm
            ];
            shellHook = ''
              export NPM_CONFIG_STORE_DIR="$PWD/.pnpm-store"

              echo "You may:"
              echo "- run \`$ nix run .#installAllPnpmDeps\` to install pnpm dependencies in all projects"
              echo "- run \`$ pnpm run dev\` in an *individual project* to get started (pnpm, not npm!)"
            '';
          };
        }
      );

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

          installAllPnpmDeps = pkgs.writeShellScriptBin "install-all-pnpm-deps" ''
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
            inherit installAllPnpmDeps;
            combined = allTalksCombinedDrv;
            default = allTalksCombinedDrv;
          }
          // allTalksAttrs
        )
      );
    };
}
