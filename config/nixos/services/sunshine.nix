{
  lib,
  pkgs,
  config,
  ...
}: {
  options.erebus.services.sunshine.enable = lib.mkEnableOption "Sunshine Game Streaming";

  config = lib.mkIf config.erebus.services.sunshine.enable {
    services.sunshine = {
      enable = true;
      autoStart = true;
      capSysAdmin = true; # Wayland
      openFirewall = true;
      applications.apps =
        lib.lists.forEach [
          {
            name = "Desktop";
            auto-detach = "true";
          }
          {
            name = "Steam Big Picture";
            detached = ["${lib.getExe' pkgs.util-linux "setsid"} ${lib.getExe pkgs.steam} steam://open/bigpicture"]; # TODO: This doesn't work all of the time.
          }
          {
            name = "Pegasus";
            cmd = "kstart ${lib.getExe pkgs.pegasus-frontend}";
          }
        ] (attr:
          attr
          // {
            exclude-global-prep-cmd = "false";
            prep-cmd = let
              kscreen = lib.getExe pkgs.kdePackages.libkscreen;
              grandr = lib.getExe pkgs.gnome-randr;

              gnome = config.erebus.desktop.gnome.enable;

              do =
                if gnome
                then "sh -c \"${grandr} modify -m \${SUNSHINE_CLIENT_WIDTH}x\${SUNSHINE_CLIENT_HEIGHT}@\${SUNSHINE_CLIENT_FPS} DP-3\""
                else "sh -c \"${kscreen} output.DP-3.mode.\${SUNSHINE_CLIENT_WIDTH}x\${SUNSHINE_CLIENT_HEIGHT}@\${SUNSHINE_CLIENT_FPS}\"";

              undo =
                if gnome
                then "${grandr} modify -m 3440x1440@165.001+vrr DP-3"
                else "${kscreen} output.DP-2.mode.3440x1440@165";
            in [
              {
                inherit do undo;
              }
            ];
          });
    };
  };
}
