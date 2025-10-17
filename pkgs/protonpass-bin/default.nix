{
  stdenvNoCC,
  sources,
  lib,
  pkgs,
  ...
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  inherit (sources.protonpass-bin) pname version src;

  phases = [
    "unpackPhase"
    "installPhase"
  ];

  buildInputs = [ pkgs._7zz ];

  unpackPhase = ''
    7zz x -snld $src
  '';

  installPhase = ''
    mkdir -p $out/Applications
    mv "ProtonPass_${finalAttrs.version}/Proton Pass.app" $out/Applications
  '';

  meta = {
    maintainers = with lib.maintainers; [ skiletro ];
  };
})
