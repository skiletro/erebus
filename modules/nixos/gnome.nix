{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkOption mkEnableOption;
  inherit (lib.types) listOf package;
  cfg = config.services.desktopManager.gnome;
in
{
  options.services.desktopManager.gnome = {
    extensions = mkOption {
      type = listOf package;
      default = [ ];
    };
    thumbnailers = mkOption {
      type = listOf package;
      default = [ ];
    };
    fixes.enable = mkEnableOption "gnome fixes and tweaks";
  };

  config = mkIf cfg.enable {
    environment.systemPackages =
      cfg.extensions
      ++ cfg.thumbnailers
      ++ (with pkgs; [
        adwaita-icon-theme # fixes some missing icons
        adwaita-icon-theme-legacy # fixes some missing icons
        gjs # fixes ding ext
        libheif
        libheif.out # HEIC Image Previews
        mission-center # Task Manager
        papers # Pdf viewer
        showtime # Video Player
        smile # Emoji picker
      ]);

    environment.gnome.excludePackages = with pkgs; [
      epiphany
      evince
      geary
      gnome-connections
      gnome-contacts
      gnome-console
      gnome-maps
      gnome-tour
      gnome-software
      seahorse
      simple-scan
      totem
    ];

    environment.pathsToLink = mkIf (cfg.thumbnailers != [ ]) [
      "share/thumbnailers"
    ];

    # Fixes
    services.udev.packages = mkIf cfg.fixes.enable [ pkgs.gnome-settings-daemon ];

    nixpkgs.overlays = mkIf cfg.fixes.enable [
      (_final: prev: {
        nautilus = prev.nautilus.overrideAttrs (nprev: {
          buildInputs =
            nprev.buildInputs
            ++ (with pkgs.gst_all_1; [
              gst-plugins-good
              gst-plugins-bad
            ]);
        });
      })
    ];

    home-manager.sharedModules = lib.singleton {
      stylix.iconTheme = mkIf cfg.fixes.enable {
        enable = true;
        package = pkgs.morewaita-icon-theme;
        dark = "MoreWaita";
        light = "MoreWaita";
      };

      dconf = {
        enable = lib.mkDefault true;
        settings = {
          "org/gnome/shell" = {
            disable-user-extensions = false;
            enabled-extensions =
              map (ext: ext.extensionUuid) cfg.extensions
              ++ lib.optional config.stylix.enable "user-theme@gnome-shell-extensions.gcampax.github.com";
          };
        };
      };
    };
  };
}
