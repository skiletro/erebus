{
  pkgs,
  lib,
  config,
  self',
  ...
}:
{
  options.erebus.desktop.hyprland.enable = lib.mkEnableOption "Hyprland, configured with DMS.";

  config = lib.mkIf config.erebus.desktop.hyprland.enable {
    programs.hyprland = {
      enable = true;
      package = pkgs.hyprland;
    };

    security.polkit.enable = lib.mkDefault true;
    services.gnome.gnome-keyring.enable = lib.mkDefault true;
    erebus.programs.dms.enable = true;

    home-manager.sharedModules = lib.singleton {
      wayland.windowManager.hyprland = {
        enable = true;
        plugins = with pkgs.hyprlandPlugins; [ hypr-dynamic-cursors ];
        settings =
          let
            dms = cmd: "dms ipc call ${cmd}";
            pctl = cmd: "${lib.getExe pkgs.playerctl} -p spotify ${cmd}";
          in
          {
            input = {
              kb_layout = "gb";
              follow_mouse = 1;
              sensitivity = 0.6;
              accel_profile = "flat";
            };

            monitor = "DP-3,3440x1440@165,0x0,1";

            bind = [
              "SUPER, Return, exec, ${lib.getExe pkgs.ghostty}"
              "SUPER SHIFT, S, exec, ${lib.getExe pkgs.grimblast} save area - | ${lib.getExe pkgs.satty} -f - --initial-tool=brush --copy-command=wl-copy --actions-on-escape='save-to-clipboard,exit' --disable-notifications"
              "SUPER, Space, exec, ${dms "spotlight toggle"}"
              "SUPER, F, exec, ${lib.getExe self'.packages.helium-bin}"
              "SUPER, E, exec, ${lib.getExe pkgs.nautilus}"

              "SUPER SHIFT, Q, killactive"
              "SUPER SHIFT, F, fullscreen"
              "SUPER SHIFT, Space, togglefloating"

              "SUPER, P, exec, ${dms "processlist toggle"}"
              "SUPER, N, exec, ${dms "notifications toggle"}"
              "SUPER SHIFT, P, exec, ${dms "powermenu toggle"}"
              "SUPER, Period, exec, ${dms "spotlight openQuery ':'"}"
              "SUPER, L, exec, ${dms "lock lock"}"
              "SUPER SHIFT, L, exec, ${lib.getExe pkgs.hyprpicker} | ${lib.getExe' pkgs.wl-clipboard "wl-copy"}"

              "SUPER, Left, movefocus, l"
              "SUPER, Right, movefocus, r"
              "SUPER, Up, movefocus, u"
              "SUPER, Down, movefocus, d"

              "SUPER SHIFT, Left, movewindow, l"
              "SUPER SHIFT, Right, movewindow, r"
              "SUPER SHIFT, Up, movewindow, u"
              "SUPER SHIFT, Down, movewindow, d"
            ]
            ++ (builtins.concatLists (
              builtins.genList (
                i:
                let
                  ws = i + 1;
                in
                [
                  "SUPER, code:1${toString i}, workspace, ${toString ws}"
                  "SUPER SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
                ]
              ) 9
            ));

            bindl = map (command: ", XF86${command}") [
              "AudioRaiseVolume, exec, ${dms "audio increment 2"}"
              "AudioLowerVolume, exec, ${dms "audio decrement 2"}"
              "AudioNext, exec, ${dms "mpris next"}"
              "AudioPrev, exec, ${dms "mpris previous"}"
              "AudioPlay, exec, ${dms "mpris playPause"}"
              "Launch9, exec, ${pctl "volume 0.02+"}"
              "Launch8, exec, ${pctl "volume 0.02-"}"
            ];

            bindm = [
              "SUPER, mouse:272, movewindow"
              "SUPER, mouse:273, resizewindow"
            ];

            general = {
              gaps_in = 3;
              gaps_out = 6;
              border_size = 2;
              no_border_on_floating = true;
            };

            decoration = {
              rounding = 8;
              blur = {
                enabled = true;
                size = 3;
                passes = 2;
                noise = 0.05;
                popups = true;
                popups_ignorealpha = 0.3;
              };
            };

            animation = [
              "workspaces, 1, 1, default, slidevert"
              "windows, 1, 1, default"
              "fade, 0"
            ];

            exec-once = [
              "${lib.getExe pkgs.dex} -a"
              "${lib.getExe pkgs.tailscale} systray"
              "${lib.getExe' pkgs.udiskie "udiskie"}"
              "${lib.getExe pkgs.wl-clip-persist} --clipboard regular"
            ];

            misc = {
              disable_hyprland_logo = true;
              disable_splash_rendering = true;
              vrr = 3;
            };

            layerrule = [
              "noanim, ^(quickshell)$"
              "blur, ^(dms:.*)$"
              "ignorealpha 0.3, ^(dms:.*)"
            ];
          };
      };

      dconf = {
        enable = lib.mkForce true;
        settings."org/gnome/desktop/wm/preferences".button-layout = lib.mkForce "";
      };
    };
  };
}
