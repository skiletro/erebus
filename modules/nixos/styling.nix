{
  lib,
  config,
  pkgs,
  inputs,
  self',
  ...
}: {
  options.erebus.system.styling = {
    enable = lib.mkEnableOption "Stylix and other styling";
    colorScheme = lib.mkOption {
      description = "What base16-schemes scheme to use.";
      type = lib.types.str;
      default = "gruvbox";
    };
    wallpaper = lib.mkOption {
      description = "What wallpaper should be used? This will be themed with the colour scheme.";
      type = lib.types.nullOr lib.types.path;
      default = null;
    };
  };

  config = lib.mkIf config.erebus.system.styling.enable {
    stylix = {
      enable = true;
      base16Scheme = "${self'.packages.base16-schemes-unstable}/share/themes/${config.erebus.system.styling.colorScheme}.yaml";
      image = pkgs.runCommand "output.png" {} "${lib.getExe pkgs.lutgen} apply ${config.erebus.system.styling.wallpaper} -o $out -- ${builtins.concatStringsSep " " config.lib.stylix.colors.toList}";
      cursor = {
        package = with config.lib.stylix.colors.withHashtag;
          inputs.cursors.packages.${pkgs.system}.bibata-modern-cursor.override {
            background_color = base00;
            outline_color = base06;
            accent_color = base00;
          };
        name = "Bibata-Modern-Custom";
        size = 24;
      };
      fonts = {
        sansSerif = {
          package = pkgs.work-sans;
          name = "Work Sans";
        };
        serif = config.stylix.fonts.sansSerif; # Set serif font to the same as the sans-serif
        monospace = {
          package = self'.packages.liga-sfmono-nerd-font;
          name = "Liga SFMono Nerd Font";
        };
        emoji = {
          package = self'.packages.apple-emoji;
          name = "Apple Color Emoji";
        };

        sizes = {
          applications = 10;
          desktop = 10;
          popups = 10;
          terminal = 12;
        };
      };
    };

    home-manager.sharedModules = lib.singleton {
      dconf = {
        enable = lib.mkDefault true;
        settings = {
          "org/gnome/desktop/interface".color-scheme = lib.mkForce "prefer-dark";
        };
      };

      stylix.iconTheme = {
        enable = true;
        package = pkgs.morewaita-icon-theme;
        dark = "MoreWaita";
        light = "MoreWaita";
      };
    };
  };
}
