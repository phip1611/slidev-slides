{
  description = "My Slidev slides";

  inputs = {
    # pnpm builders change often, affecting build hashes. keep in sync
    # with my nixos-configs repo.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
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
          depHash = "sha256-+Ro1c7eS5ROiDwp5oTtGaaDhTeb1lJk7hzLp98EIMlM=";
          meta = {
            slug = "eurorust-2025";
            title = "A Minimal Rust Kernel - Printing to QEMU with core::fmt";
          };
        }
        {
          src = ./2025-10-cyberus-combine-demo;
          depHash = "sha256-X8NpgiDhuXBAPm0G+GutV5NDVmM3cq6fLSnjTE4zTSk=";
          meta = {
            slug = "cyberus-combine-2025-10";
            title = "Slidev demo for Cyberus Combine";
          };
        }
        {
          src = ./2025-11-jug-saxony-writing-an-os-loader-in-rust;
          depHash = "sha256-X8NpgiDhuXBAPm0G+GutV5NDVmM3cq6fLSnjTE4zTSk=";
          meta = {
            slug = "jug-saxony-loader-uefi-rs-2025-11";
            title = "Writing an OS-Loader in Rust with uefi-rs";
          };
        }
        {
          src = ./2026-03-cyberus-tech-talk-the-art-of-serial;
          depHash = "sha256-81TlfiuHcEH7DjTCA003WyuGIwxtT4hh81TPs94yr8s=";
          meta = {
            slug = "cyberus-tech-talk-the-art-of-serial";
            title = "The (U)Art of Serial - A 16550 Deep Dive";
          };
        }
        {
          src = ./2026-06-rust-for-osdev-at-rust-dresden;
          depHash = "sha256-c+ebrbi+jjzzYFxIAeHimDhHrsFh82/M4et9h7vRAl8=";
          meta = {
            slug = "rust-for-os-development";
            title = "Rust for OS Development";
          };
        }
        {
          src = ./2026-08-cyberus-combine;
          depHash = "sha256-lZn7Yea/icSBBwNpIIwwV9bc0lTugrh5TFHbNQ3TxYs=";
          meta = {
            slug = "2026-08-cyberus-combine";
            title = "Cyberus Combine: How to become a better speaker";
          };
        }
        {
          src = ./2026-08-new-template;
          depHash = "sha256-cyWWKnSP2oFtknmM9Z4L/dQwhhfJhBLuS1RoLq5oR/U=";
          meta = {
            slug = "new-template";
            title = "New Slidev Template Playground";
          };
        }
        {
          src = ./2026-09-what-is-a-vm-jsd;
          depHash = "sha256-DUP0+HMwftiQ1JObE8ysQHGYW62dTfKC31SZ3l3Wss4=";
          meta = {
            slug = "virtualization-saxony-jsd26";
            title = "Virtualization Made in Saxony";
          };
        }
        {
          src = ./2026-10-eurorust;
          depHash = "sha256-DUP0+HMwftiQ1JObE8ysQHGYW62dTfKC31SZ3l3Wss4=";
          meta = {
            slug = "eurorust-2026-inside-cloud-hypervisor";
            title = "Inside Cloud Hypervisor: From KVM to a Running VM";
          };
        }
      ];

      # Builds a single slidev project.
      buildProject =
        pkgs:
        {
          src,
          depHash ? pkgs.lib.fakeHash,
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
