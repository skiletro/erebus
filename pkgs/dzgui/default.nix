{
  lib,
  pkgs,
  sources,
  ...
}:
let
  desktopFile =
    (pkgs.makeDesktopItem {
      type = "Application";
      terminal = false;
      exec = "dzgui";
      name = "DZGUI";
      desktopName = "DZGUI";
      icon = "dzgui";
      categories = [ "Game" ];
    })
    + /share/applications/DZGUI.desktop;
in
pkgs.stdenvNoCC.mkDerivation (finalAttrs: {
  inherit (sources.dzgui) pname version src;

  postPatch = ''
    sed -i 's@/usr/bin/zenity@zenity@g' dzgui.sh
    sed -i '/    check_map_count/d' dzgui.sh
    sed -i '/    check_version/d' dzgui.sh
    sed -i '/    write_desktop_file >/d' dzgui.sh
  '';

  nativeBuildInputs = with pkgs; [
    makeWrapper
    gobject-introspection
    wrapGAppsHook3
  ];

  runtimeDeps = with pkgs; [
    curl
    jq
    (python3.withPackages (p: with p; [ pygobject3 ]))

    wmctrl
    xdotool
    zenity
  ];

  installPhase = ''
    install -DT dzgui.sh $out/bin/dzgui

    install -DT ${desktopFile} $out/share/applications/dzgui.desktop
    install -DT images/dzgui $out/share/icons/hicolor/256x256/apps/dzgui.png
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH ':' ${lib.makeBinPath finalAttrs.runtimeDeps}
    )
  '';

  meta = with lib; {
    homepage = "https://codeberg.org/aclist/dztui";
    description = "DayZ TUI/GUI server browser";
    license = licenses.gpl3;

    longDescription = ''
      DZGUI allows you to connect to both official and modded/community DayZ
      servers on Linux and provides a graphical interface for doing so.
    '';

    platforms = platforms.all;
  };
})
