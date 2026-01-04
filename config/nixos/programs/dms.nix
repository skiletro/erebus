{
  lib,
  config,
  pkgs,
  inputs',
  ...
}:
{
  options.erebus.programs.dms.enable = lib.mkEnableOption "Dank Material Shell";

  config = lib.mkIf config.erebus.programs.dms.enable {
    programs.dms-shell = {
      enable = true;
      quickshell.package = inputs'.quickshell.packages.quickshell;
      enableDynamicTheming = false; # we use stylix instead
    };

    home-manager.sharedModules = lib.singleton (attrs: {
      erebus.services.calendar.enable = true;

      home =
        let
          inherit (pkgs.writers) writeNuBin writeJSON;

          dmsPath = ".config/DankMaterialShell";

          colorTheme = with config.lib.stylix.colors.withHashtag; {
            dark = {
              name = "Stylix generated dark theme";
              primary = base0D;
              primaryText = base00;
              primaryContainer = base0C;
              secondary = base0E;
              surface = base01;
              surfaceText = base05;
              surfaceVariant = base02;
              surfaceVariantText = base04;
              surfaceTint = base0D;
              background = base00;
              backgroundText = base05;
              outline = base03;
              surfaceContainer = base01;
              surfaceContainerHigh = base02;
              surfaceContainerHighest = base03;
              error = base08;
              warning = base0A;
              info = base0C;
            };

            light = {
              name = "Stylix generated light theme";
              primary = base0D;
              primaryText = base07;
              primaryContainer = base0C;
              secondary = base0E;
              surface = base06;
              surfaceText = base01;
              surfaceVariant = base07;
              surfaceVariantText = base02;
              surfaceTint = base0D;
              background = base07;
              backgroundText = base00;
              outline = base04;
              surfaceContainer = base06;
              surfaceContainerHigh = base05;
              surfaceContainerHighest = base04;
              error = base08;
              warning = base0A;
              info = base0C;
            };
          };

          settingsPath = "/home/jamie/${dmsPath}/settings.json";

          setDmsConfigScript =
            writeNuBin "setDmsConfig"
              # nu
              ''
                if ('${settingsPath}' | path exists) {
                  print "Setting Stylix theming for DMS."
                  open ${settingsPath}
                  | update currentThemeName "custom"
                  | update customThemeFile "${writeJSON "dms-stylix.json" colorTheme}"
                  | save -f ${settingsPath}
                  print "Stylix theming for DMS set."
                } else {
                  print "DMS Settings file does not exist... Skipping..." 
                }
              '';
        in
        {
          activation.useStylixWithDMS = attrs.config.lib.dag.entryAfter [ "writeBoundary" ] ''
            run ${lib.getExe setDmsConfigScript}
          '';

          packages = with pkgs; [
            dgop
            dsearch
          ];
        };
    });
  };
}
