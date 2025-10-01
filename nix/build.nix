# Returns a function building a derivation for a single pnpm-based slidev project.

{
  # Helpers
  stdenv,

  # Packages
  nodejs,
  pnpm,

  # Config
  pname,
  depHash,
  meta,
  src,
}:

stdenv.mkDerivation (finalAttrs: {
  inherit meta pname src;
  version = "0.0.0";

  nativeBuildInputs = [
    nodejs
    pnpm.configHook
  ];

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 2;
    hash = depHash;
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
