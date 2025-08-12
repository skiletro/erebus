{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  options.erebus.desktop.gnome.enable = lib.mkEnableOption "Gnome desktop and accompanying programs.";

  imports = [self.nixosModules.gnome];

  config = lib.mkIf config.erebus.desktop.gnome.enable {
    services.displayManager.gdm.enable = true;

    services.desktopManager.gnome = {
      enable = true;
      extensions = with pkgs.gnomeExtensions; [
        accent-directories
        appindicator
        color-picker
        dash-to-dock
        gtk4-desktop-icons-ng-ding
        mpris-label
        search-light
        smile-complementary-extension
        unite
        weather-oclock
      ];
    };

    environment.gnome.excludePackages = with pkgs; [
      epiphany
      evince
      geary
      gnome-connections
      gnome-contacts
      gnome-console
      gnome-maps
      gnome-music
      gnome-tour
      gnome-software
      seahorse
      simple-scan
      totem
      xorg.xprop # fixes notif spam with unite extension
    ];

    home-manager.sharedModules = lib.singleton {
      dconf = {
        enable = true;
        settings = let
          inherit (lib.gvariant) mkTuple;
        in {
          "org/gnome/mutter" = {
            attach-modal-dialogs = false;
            center-new-windows = true;
            dynamic-workspaces = true;
            edge-tiling = true;
            experimental-features = ["scale-monitor-framebuffer" "variable-refresh-rate"];
          };

          "org/gnome/shell".favorite-apps = [
            "zen-twilight.desktop"
            "org.gnome.Nautilus.desktop"
            "thunderbird.desktop"
            "com.mitchellh.ghostty.desktop"
            "vesktop.desktop"
            "spotify.desktop"
            "steam.desktop"
            "chrome-fjpeaicnionajpipomepndgbcpchdmlb-Default.desktop" # Instagram PWA
            "writer.desktop"
            "calc.desktop"
          ];

          "org/gnome/TextEditor" = {
            restore-session = false;
            style-variant = "light";
          };

          "org/gnome/desktop/interface" = {
            accent-color = "pink"; # Set this to whatever matches the colour scheme best.
            clock-format = "12h";
            clock-show-weekday = true;
            enable-animations = true;
            enable-hot-corners = false;
            gtk-enable-primary-paste = false;
          };

          "org/gnome/desktop/media-handling" = {
            autorun-never = true;
          };

          "org/gnome/desktop/peripherals/mouse" = {
            accel-profile = "flat";
            speed = 0.7;
          };

          "org/gnome/desktop/peripherals/touchpad" = {
            two-finger-scrolling-enabled = true;
          };

          "org/gnome/desktop/wm/preferences" = {
            auto-raise = true;
            button-layout = ":minimize,maximize,close";
            focus-mode = "click";
            num-workspaces = 1;
            resize-with-right-button = true;
          };

          "org/gnome/desktop/input-sources" = {
            sources = [
              (mkTuple [
                "xkb"
                "gb"
              ])
            ];
            xkb-options = [];
          };

          # Extensions
          "org/gnome/shell/extensions/appindicator" = {
            icon-opacity = 255;
            icon-size = 0;
            legacy-tray-enabled = false;
            tray-pos = "center";
          };

          "org/gnome/shell/extensions/dash-to-dock" = {
            apply-custom-theme = false;
            background-color = "rgb(36,31,49)";
            background-opacity = 0.8;
            click-action = "minimize-or-previews";
            custom-background-color = false;
            custom-theme-shrink = false;
            dash-max-icon-size = 40;
            disable-overview-on-startup = true;
            dock-fixed = false;
            dock-position = "LEFT";
            extend-height = false;
            height-fraction = 0.9;
            icon-size-fixed = true;
            intellihide-mode = "ALL_WINDOWS";
            middle-click-action = "quit";
            preferred-monitor = -2;
            preferred-monitor-by-connector = "DP-2";
            preview-size-scale = 0.0;
            running-indicator-style = "DOT";
            scroll-action = "do-nothing";
            shift-click-action = "launch";
            shift-middle-click-action = "launch";
            show-apps-at-top = false;
            show-mounts = true;
            show-mounts-only-mounted = true;
            show-show-apps-button = false;
            show-trash = false;
            transparency-mode = "DEFAULT";
            hot-keys = false;
          };

          "org/gnome/shell/extensions/blur-my-shell/dash-to-dock".pipeline = "pipeline_default";

          "org/gnome/shell/extensions/mpris-label" = {
            divider-string = " - ";
            extension-place = "center";
            icon-padding = 5;
            left-click-action = "play-pause";
            left-padding = 0;
            middle-click-action = "none";
            mpris-sources-blacklist = "Mozilla zen,Mozilla zen-twilight,Chromium";
            right-click-action = "open-menu";
            right-padding = 0;
            second-field = "";
            show-icon = "left";
            thumb-backward-action = "none";
            thumb-forward-action = "none";
            use-whitelisted-sources-only = false;
            extension-index = 0;
          };

          # Search Light
          "org/gnome/shell/extensions/search-light" = with config.lib.stylix.colors; let
            mkColor = r: g: b: mkTuple (map builtins.fromJSON [r g b] ++ [1.0]);
          in {
            "shortcut-search" = ["<Super>d"];
            "border-radius" = 1.1;
            "background-color" = mkColor base00-dec-r base00-dec-g base00-dec-b;
            "text-color" = mkColor base05-dec-r base05-dec-g base05-dec-b;
            "border-color" = mkColor base01-dec-r base01-dec-g base01-dec-b;
            "border-thickness" = 1;
            "scale-width" = 0.17;
            "scale-height" = 0.2;
            "popup-at-cursor-monitor" = true;
          };

          "org/gnome/shell/extensions/unite" = {
            "hide-activities-button" = "never";
            "use-activities-text" = false;
            "show-desktop-name" = false;
            "hide-window-titlebars" = "never";
            "show-window-buttons" = "never";
            "show-window-title" = "never";
          };

          # Ding
          "org/gnome/shell/extensions/gtk4-ding" = {
            start-corner = "top-right";
            show-drop-place = false;
            show-home = false;
            show-trash = false;
            show-volumes = false;
          };

          # Smile (Emoji Selector)
          "it/mijorus/smile" = {
            is-first-run = false;
            load-hidden-on-startup = true;
          };

          "org/gnome/shell/extensions/color-picker" = {
            enable-shortcut = true;
            color-picker-shortcut = ["<Super>l"];
            enable-systray = false;
          };
        };
      };
    };
  };
}
