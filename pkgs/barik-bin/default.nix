{
  sources,
  lib,
  stdenvNoCC,
  unzip,
  ...
}:
stdenvNoCC.mkDerivation {
  inherit (sources.barik-bin) pname version src;

  unpackPhase = ''
    ${lib.getExe unzip} $src
  '';

  installPhase = ''
    mkdir -p $out/Applications
    mv Barik.app $out/Applications
  '';

  meta = {
    description = "macOS menu bar replacement, with yabai and AeroSpace support";
    homepage = "https://github.com/mocki-toki/barik";
    maintainers = with lib.maintainers; [ skiletro ];
    platforms = lib.platforms.darwin;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
