# Returns a function building a derivation for a single npm-based slidev project.

{
  # Helpers
  lib,
  stdenv,

  # Packages
  importNpmLock,
  nodejs,

  # Config
  pname,
  meta,
  src,
}:

stdenv.mkDerivation (finalAttrs: {
  inherit meta pname src;
  version = "0.0.0";

  nativeBuildInputs = [
    nodejs
    importNpmLock.npmConfigHook
  ];

  # Fetches each package with the integrity hash from package-lock.json, so
  # no dependency hash needs to be maintained.
  npmDeps = importNpmLock {
    inherit (finalAttrs) pname version;
    package = lib.importJSON "${src}/package.json";
    packageLock = lib.importJSON "${src}/package-lock.json";
  };

  buildPhase = ''
    runHook preBuild
    npm run build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -r dist/. $out
    runHook postInstall
  '';
})
