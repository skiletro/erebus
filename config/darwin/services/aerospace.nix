{
  lib,
  config,
  pkgs,
  ...

}:
{
  options.erebus.services.aerospace.enable = lib.mkEnableOption "Aerospace window manager";

  config = lib.mkIf config.erebus.services.aerospace.enable {
    homebrew = {
      casks = [
        "sol"
        "swipeaerospace"
      ]; # TODO: package and add module
      taps = [ "mediosz/tap" ];
    };

    system.activationScripts."aerospace-restart".text = ''
      launchctl stop org.nixos.aerospace
    '';

    services.aerospace = {
      enable = true;
      settings = {
        after-startup-command = [
          "exec-and-forget open -a Barik.app"
          "exec-and-forget open -a SwipeAeroSpace.app"
          "exec-and-forget open -a Sol.app"
          "exec-and-forget ${lib.getExe pkgs.jankyborders} active_color=0xff${config.lib.stylix.colors.base05} inactive_color=0xff${config.lib.stylix.colors.base00} width=4.0"
        ];

        enable-normalization-flatten-containers = true;
        enable-normalization-opposite-orientation-for-nested-containers = true;

        default-root-container-layout = "tiles";
        default-root-container-orientation = "auto";

        on-focus-changed = [ "move-mouse window-lazy-center" ];

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
              top = [
                { monitor.main = padding + 25; }
                padding
              ];
            };
          };

        on-window-detected = [
          {
            "if".app-id = "org.godotengine.godot";
            run = [ "layout floating" ];
          }
        ];

        # put the second workspace on laptop in case of docked.
        workspace-to-monitor-force-assignment."2" = "secondary";

        mode = {
          main.binding = lib.mapAttrs' (n: v: lib.nameValuePair "cmd-${n}" v) {
            # enter = ''
            #   exec-and-forget osascript -e '
            #     tell application "Ghostty"
            #   	if it is running then
            #   		activate
            #   		tell application "System Events" to keystroke "n" using {command down}
            #   	else
            #   		activate
            #   	end if
            #       end tell'
            # '';
            enter = ''
              exec-and-forget osascript -e '
                tell application "Ghostty"
                    if it is running
                        tell application "System Events" to tell process "Ghostty"
                            click menu item "New Window" of menu "File" of menu bar 1
                        end tell
                    else
                        activate
                    end if
                end tell
              '
            '';
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

            alt-s = "layout v_accordion";
            alt-w = "layout h_accordion";
            alt-e = "layout tiles horizontal vertical";
          };
        };

      };
    };
    erebus.services.barik.enable = lib.mkDefault true;
  };
}
