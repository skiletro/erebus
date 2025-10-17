{
  stdenvNoCC,
  sources,
  lib,
  pkgs,
  ...
}:
stdenvNoCC.mkDerivation {
  inherit (sources.protonvpn-bin) pname version src;

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
    mv ProtonVPN/ProtonVPN.app $out/Applications
  '';

  meta = {
    maintainers = with lib.maintainers; [ skiletro ];
  };
}
