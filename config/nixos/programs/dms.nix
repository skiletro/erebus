{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
{
  options.erebus.programs.dms.enable = lib.mkEnableOption "Dank Material Shell";

  imports = [ inputs.dms.nixosModules.dank-material-shell ];

  config = lib.mkIf config.erebus.programs.dms.enable {
    programs.dank-material-shell = {
      enable = true;
      enableSystemMonitoring = true;
      enableVPN = true;
      enableDynamicTheming = false; # we use stylix instead
      enableAudioWavelength = true;
      enableCalendarEvents = true;
      enableClipboardPaste = true;
    };

    home-manager.sharedModules = lib.singleton {
      imports = [ inputs.dms.homeModules.dank-material-shell ];

      erebus.services.calendar.enable = true;

      programs.dank-material-shell = {
        enable = true;
        managePluginSettings = true;
        settings = {
          fontFamily = config.stylix.fonts.sansSerif.name;
          monoFontFamily = config.stylix.fonts.monospace.name;

          cornerRadius = 0;
          showSeconds = false;
          useFahrenheit = false;
          use24HourClock = false;

          modalDarkenBackground = false;

          animationSpeed = 4;
          customAnimationDuration = 400; # ms
          wallpaperFillMode = "Fill";
          blurredWallpaperLayer = false;
          blurWallpaperOnOverview = false;
          showLauncherButton = true;
          showWorkspaceSwitcher = true;
          showFocusedWindow = true;
          showWeather = true;
          showMusic = true;
          showClipboard = true;
          showCpuUsage = true;
          showMemUsage = true;
          showCpuTemp = true;
          showGpuTemp = true;
          selectedGpuIndex = 0;
          enabledGpuPciIds = [ ];
          showSystemTray = true;
          showClock = true;
          showNotificationButton = true;
          showBattery = true;
          showControlCenterButton = true;
          showCapsLockIndicator = true;
          controlCenterShowNetworkIcon = true;
          controlCenterShowBluetoothIcon = true;
          controlCenterShowAudioIcon = true;
          controlCenterShowAudioPercent = false;
          controlCenterShowVpnIcon = true;
          controlCenterShowBrightnessIcon = false;
          controlCenterShowBrightnessPercent = false;
          controlCenterShowMicIcon = false;
          controlCenterShowMicPercent = false;
          controlCenterShowBatteryIcon = false;
          controlCenterShowPrinterIcon = false;
          showPrivacyButton = true;
          privacyShowMicIcon = false;
          privacyShowCameraIcon = false;
          privacyShowScreenShareIcon = false;

          # Screen settings
          screenPreferences = {
            dankBar = [
              "all"
            ];
            wallpaper = [ ];
          };
          showOnLastDisplay = {
            dankBar = true;
          };

          # Icon substitutions
          appIdSubstitutions = [
            {
              pattern = "Spotify";
              replacement = "spotify";
              type = "exact";
            }
            {
              pattern = "^steam_app_(\\d+)$";
              replacement = "steam_icon_$1";
              type = "regex";
            }
            {
              pattern = "Proton Mail";
              replacement = "proton-mail";
              type = "exact";
            }
            {
              pattern = "Proton Pass";
              replacement = "proton-pass";
              type = "exact";
            }
          ];

          # Dock settings
          showDock = true;
          dockAutoHide = false;
          dockSmartAutoHide = true;
          dockGroupByApp = false;
          dockOpenOnOverview = false;
          dockPosition = 1;
          dockSpacing = 9;
          dockMargin = 10;
          dockIconSize = 50;

          # Bar settings
          barConfigs = [
            {
              id = "default";
              name = "Main Bar";
              enabled = true;
              position = 2;
              screenPreferences = [
                "all"
              ];
              showOnLastDisplay = true;
              leftWidgets = [
                {
                  id = "workspaceSwitcher";
                  enabled = true;
                }
              ];
              centerWidgets = [
                {
                  id = "clock";
                  enabled = true;
                }
                {
                  id = "spacer";
                  enabled = true;
                  size = 20;
                }
                {
                  id = "weather";
                  enabled = true;
                }
              ];
              rightWidgets = [
                {
                  id = "music";
                  enabled = true;
                }
                {
                  id = "spacer";
                  enabled = true;
                  size = 15;
                }
                {
                  id = "systemTray";
                  enabled = true;
                }
                {
                  id = "spacer";
                  enabled = true;
                  size = 10;
                }
                {
                  id = "notificationButton";
                  enabled = true;
                }
                {
                  id = "controlCenterButton";
                  enabled = true;
                }
                {
                  id = "spacer";
                  enabled = true;
                  size = 5;
                }
              ];
              spacing = 5;
              innerPadding = 4;
              bottomGap = 0;
              transparency = 0;
              widgetTransparency = 0;
              squareCorners = true;
              noBackground = false;
              gothCornersEnabled = false;
              gothCornerRadiusOverride = false;
              gothCornerRadiusValue = 54;
              borderEnabled = false;
              borderColor = "surfaceText";
              borderOpacity = 1;
              borderThickness = 1;
              fontScale = 1;
              autoHide = false;
              autoHideDelay = 250;
              openOnOverview = false;
              visible = true;
              popupGapsAuto = true;
              popupGapsManual = 4;
              maximizeDetection = true;
              widgetOutlineEnabled = false;
              widgetOutlineThickness = 2;
              widgetOutlineColor = "surfaceText";
            }
          ];
          showWorkspaceApps = true;
          showWorkspaceIndex = true;
          maxWorkspaceIcons = 5;
          groupWorkspaceApps = false;

          # Color scheme (stylix)
          currentThemeName = "custom";
          currentThemeCategory = "generic";
          customThemeFile =
            let
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
            pkgs.writers.writeJSON "dms-stylix.json" colorTheme;

          # Control center settings
          controlCenterWidgets = [
            {
              id = "volumeSlider";
              enabled = true;
              width = 50;
            }
            {
              id = "brightnessSlider";
              enabled = true;
              width = 50;
            }
            {
              id = "bluetooth";
              enabled = true;
              width = 50;
            }
            {
              id = "audioOutput";
              enabled = true;
              width = 50;
            }
            {
              id = "audioInput";
              enabled = true;
              width = 50;
            }
            {
              id = "colorPicker";
              enabled = true;
              width = 50;
            }
            {
              id = "builtin_vpn";
              enabled = true;
              width = 50;
            }
            {
              id = "diskUsage";
              enabled = true;
              width = 50;
              instanceId = "mktvkfz3tysbvmtwsns9t6c9d1ya5";
              mountPath = "/";
            }
            {
              id = "builtin_cups";
              enabled = true;
              width = 50;
            }
            {
              id = "nightMode";
              enabled = true;
              width = 50;
            }
          ];
        };
      };
    };
  };
}
