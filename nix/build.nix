# Returns a function building a derivation for a single pnpm-based slidev project.

{
  # Helpers
  stdenv,

  # Packages
  nodejs,
  pnpm,

  # Config
  pname,
  hash,
  src,
}:

stdenv.mkDerivation (finalAttrs: {
  inherit hash pname src;
  version = "0.0.0";

  nativeBuildInputs = [
    nodejs
    pnpm.configHook
  ];

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 2;
    inherit hash;
  };

  buildPhase = ''
    runHook preBuild
    npm run build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/${pname}
    cp -r dist/. $out/${pname}
    runHook postInstall
  '';
})
