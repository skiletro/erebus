{
  lib,
  config,
  self,
  pkgs,
  ...
}:
{
  options.erebus.services.barik.enable = lib.mkEnableOption "Barik status bar";

  imports = [ self.darwinModules.barik ];

  config = lib.mkIf config.erebus.services.barik.enable {
    services.barik = {
      enable = true;
      settings = {
        aerospace.path = lib.getExe pkgs.aerospace;
        widgets = {
          displayed = [
            "default.spaces"
            "spacer"
            "default.nowplaying"
            "default.network"
            "default.battery"
            # "divider"
            "default.time"
          ];

          spaces = {
            space.show-key = true;
            window.show-title = true;
            window.title.max-length = 45;
            window.title.always-display-app-name-for = [
              "Orion"
              "Ghostty"
            ];
          };

          battery = {
            show-percentage = true;
            warning-level = 30;
            critical-level = 10;
          };

          time = {
            format = "E d, J:mm";
            calendar.format = "J:mm";
            calendar.show-events = true;
          };
        };

        # sets the height to something a bit smaller, as to not take up as much space
        experimental = {
          background = {
            height = "menu-bar";
            displayed = false;
          };
          foreground.height = "menu-bar";
        };

        theme = "system";
      };
    };
  };
}
