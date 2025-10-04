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

  meta.description = "WheelWizard, Retro Rewind Launcher";
}
