{
  inputs,
  inputs',
  lib,
  config,
  pkgs,
  ...
}:
{
  options.erebus.programs.dms.enable = lib.mkEnableOption "Dank Material Shell";

  config = lib.mkIf config.erebus.programs.dms.enable {
    home-manager.sharedModules = [
      {
        imports = [ inputs.dankMaterialShell.homeModules.dankMaterialShell.default ];

        programs.dankMaterialShell = {
          enable = true;

          # Core features
          enableSystemd = true; # Systemd service for auto-start
          enableSystemMonitoring = true; # System monitoring widgets (dgop)
          enableVPN = true; # VPN management widget
          enableColorPicker = true; # Color picker tool
          enableAudioWavelength = true; # Audio visualizer (cava)
          enableCalendarEvents = true; # Calendar integration (khal)
          enableSystemSound = true; # System sound effects
        };

        home.packages = [ inputs'.dsearch.packages.default ];

        home.file =
          let
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
          in
          {
            "${dmsPath}/stylix-colors.json".text = builtins.toJSON colorTheme;
            "${dmsPath}/plugins/emojiPicker" = {
              recursive = true;
              source = pkgs.fetchFromGitHub {
                owner = "devnullvoid";
                repo = "dms-emoji-launcher";
                rev = "bcfa0e72dafd2127d37f9c3d5d1ea6227432c969";
                sha256 = "sha256-h4+6OurB9yo4mJUye9z1PdUjjqTNIur78Y5IrRPY1g0=";
              };
            };
          };
      }
    ];
  };
}
