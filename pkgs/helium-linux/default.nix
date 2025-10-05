{
  appimageTools,
  sources,
  lib,
  ...
}:
let
  pname = "helium-linux";
  inherit (sources.helium-x86_64-linux) version src;

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

  meta = {
    description = "Privacy-focused browser based on ungoogled-chromium";
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ skiletro ];
  };
}
