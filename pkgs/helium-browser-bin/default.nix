{
  sources,
  stdenvNoCC,
  pkgs,
  lib,
  ...
}:
stdenvNoCC.mkDerivation {
  inherit (sources.helium-browser-bin) pname version src;

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
    mv Helium.app $out/Applications
  '';

  meta = {
    description = "Chromium-based web browser";
    maintainers = with lib.maintainers; [ skiletro ];
    platforms = [ "aarch64-darwin" ];
  };
}
