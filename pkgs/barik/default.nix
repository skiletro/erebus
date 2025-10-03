{
  fetchzip,
  lib,
  stdenvNoCC,
  ...
}:
let
  pname = "barik";
  version = "0.5.1";
in
stdenvNoCC.mkDerivation {
  inherit pname version;

  src = fetchzip {
    url = "https://github.com/mocki-toki/barik/releases/download/${version}/Barik.zip";
    sha256 = "sha256-UtC4IL8tEqkLh2HVhlATw8NhGjkD5Uhjkf0kar3BVHc=";
    stripRoot = false;
  };

  installPhase = ''
    mkdir -p $out/Applications
    mv Barik.app $out/Applications
  '';

  meta = {
    homepage = "https://github.com/mocki-toki/barik";
    platforms = lib.platforms.darwin;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
