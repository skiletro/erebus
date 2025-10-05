{
  buildDotnetModule,
  dotnetCorePackages,
  sources,
  makeDesktopItem,
  ...
}:
buildDotnetModule {
  inherit (sources.wheelwizard) pname src version;

  desktopItems = [
    (makeDesktopItem {
      name = "Wheel Wizard";
      exec = "wheelwizard";
      icon = "wheelwizard";
      comment = "Mario Kart Wii Mod Manager";
      desktopName = "Wheel Wizard";
    })
  ];

  nugetDeps = ./deps.json;

  projectFile = "WheelWizard/WheelWizard.csproj";
  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;

  postInstall = ''
    install -Dm644 $src/Flatpak/io.github.TeamWheelWizard.WheelWizard.desktop \
      $out/share/applications/io.github.TeamWheelWizard.WheelWizard.desktop
    install -Dm644 $src/Flatpak/io.github.TeamWheelWizard.WheelWizard.png \
      $out/share/icons/hicolor/256x256/apps/io.github.TeamWheelWizard.WheelWizard.png
  '';

  meta.description = "WheelWizard, Retro Rewind Launcher";
}
