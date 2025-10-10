{
  stdenvNoCC,
  appimageTools,
  sources,
  lib,
  pkgs,
  ...
}:
let
  inherit (stdenvNoCC.hostPlatform) isDarwin;

  linuxDerivation =
    let
      inherit (sources.helium-appimage) pname version src;
      appimageContents = appimageTools.extract {
        inherit pname version src;
      };
    in
    appimageTools.wrapType2 {
      inherit pname version src;

      extraInstallCommands = ''
        install -Dm644 ${appimageContents}/helium.desktop $out/share/applications/helium.desktop
        substituteInPlace $out/share/applications/helium.desktop \
          --replace "Exec=AppRun" "Exec=${pname}"

        install -Dm644 ${appimageContents}/usr/share/icons/hicolor/256x256/apps/helium.png \
          $out/share/icons/hicolor/256x256/apps/helium.png
      '';
    };

  darwinDerivation = stdenvNoCC.mkDerivation {
    inherit (sources.helium-dmg) pname version src;

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

  };
in
lib.mergeAttrs (if isDarwin then darwinDerivation else linuxDerivation) {
  meta = {
    description = "Chromium-based web browser";
    maintainers = with lib.maintainers; [ skiletro ];
  };
}
