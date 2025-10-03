{
  lib,
  config,
  pkgs,
  ...

}:
{
  options.erebus.services.aerospace.enable = lib.mkEnableOption "Aerospace window manager";

  config = lib.mkIf config.erebus.services.aerospace.enable {
    services.aerospace = {
      enable = true;
      settings = {
        after-startup-command = [
          "exec-and-forget open -a Barik.app"
          "exec-and-forget ${lib.getExe pkgs.jankyborders} active_color=0xff${config.lib.stylix.colors.base05} inactive_color=0xff${config.lib.stylix.colors.base00} width=4.0"
        ];

        enable-normalization-flatten-containers = true;
        enable-normalization-opposite-orientation-for-nested-containers = true;

        default-root-container-layout = "tiles";
        default-root-container-orientation = "auto";

        on-focused-monitor-changed = [ "move-mouse monitor-lazy-center" ];

        automatically-unhide-macos-hidden-apps = true;

        key-mapping.preset = "qwerty";

        gaps =
          let
            padding = 5;
          in
          {
            inner = {
              horizontal = padding + 4;
              vertical = padding + 4;
            };
            outer = {
              left = padding;
              bottom = padding;
              right = padding;
              top = padding + 25;
            };
          };

        on-window-detected = [
          {
            "if".app-id = "org.godotengine.godot";
            run = [ "layout floating" ];
          }
        ];

        mode = {
          main.binding = lib.mapAttrs' (n: v: lib.nameValuePair "cmd-${n}" v) {
            enter = "exec-and-forget open -a Ghostty.app";
            shift-s = "exec-and-forget screencapture -i -c";

            left = "focus left";
            right = "focus right";
            up = "focus up";
            down = "focus down";

            shift-left = "move left";
            shift-right = "move right";
            shift-up = "move up";
            shift-down = "move down";

            minus = "resize smart -50";
            equal = "resize smart +50";

            "1" = "workspace 1";
            "2" = "workspace 2";
            "3" = "workspace 3";
            "4" = "workspace 4";
            "5" = "workspace 5";
            "6" = "workspace 6";
            "7" = "workspace 7";
            "8" = "workspace 8";
            "9" = "workspace 9";

            shift-1 = "move-node-to-workspace 1";
            shift-2 = "move-node-to-workspace 2";
            shift-3 = "move-node-to-workspace 3";
            shift-4 = "move-node-to-workspace 4";
            shift-5 = "move-node-to-workspace 5";
            shift-6 = "move-node-to-workspace 6";
            shift-7 = "move-node-to-workspace 7";
            shift-8 = "move-node-to-workspace 8";
            shift-9 = "move-node-to-workspace 9";

            shift-space = [
              "layout floating tiling"
              "mode main"
            ];

            r = "mode resize";
          };

          resize.binding = {
            left = "resize width -50";
            right = "resize width +50";
            up = "resize height +50";
            down = "resize height -50";
            enter = "mode main";
            esc = "mode main";
          };
        };

      };
    };
    erebus.services.barik.enable = lib.mkDefault true;
  };
}
