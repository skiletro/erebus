{
  stdenvNoCC,
  sources,
  lib,
  pkgs,
  ...
}:
stdenvNoCC.mkDerivation {
  inherit (sources.protonmail-bin) pname version src;

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
    mv "Proton Mail/Proton Mail.app" $out/Applications
  '';

  meta = {
    maintainers = with lib.maintainers; [ skiletro ];
  };
}
