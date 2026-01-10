{
  pkgs,
  lib,
  config,
  self',
  inputs',
  ...
}:
{
  options.erebus.desktop.hyprland.enable = lib.mkEnableOption "Hyprland, configured with DMS.";

  config = lib.mkIf config.erebus.desktop.hyprland.enable {
    programs.hyprland = {
      enable = true;
      withUWSM = true;
      package = inputs'.hyprland.packages.hyprland;
      portalPackage = inputs'.hyprland.packages.xdg-desktop-portal-hyprland;
    };

    security.polkit.enable = lib.mkDefault true;
    services.gnome.gnome-keyring.enable = lib.mkDefault true;
    erebus.programs.dms.enable = true;

    # TODO: make application suites desktop-agnostic
    # currently I use the gnome suite of apps because they look nice, but i'll probably swap to dolphin file mgr
    # at the very least soon-ish.
    environment.systemPackages = with pkgs; [
      # keep-sorted start
      decibels # audio player
      file-roller # archive manager (just use ouch on cli)
      gapless # music player
      gnome-calculator
      gnome-disk-utility
      loupe # image viewer
      nautilus # file manager
      papers # document viewer
      pavucontrol
      showtime # video player
      sushi # quick previewer for nautilus
      # keep-sorted end
    ];

    home-manager.sharedModules = lib.singleton {
      wayland.windowManager.hyprland = {
        enable = true;
        systemd.enable = false;
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
              "SUPER, Return, exec, ${lib.getExe pkgs.kitty}"
              "SUPER SHIFT, S, exec, ${lib.getExe pkgs.grimblast} copy area"
              "SUPER, Space, exec, vicinae toggle"
              "SUPER, F, exec, ${lib.getExe self'.packages.helium-bin}"
              "SUPER, E, exec, ${lib.getExe pkgs.nautilus}"

              "SUPER SHIFT, Q, killactive"
              "SUPER SHIFT, F, fullscreen"
              "SUPER SHIFT, Space, togglefloating"

              "SUPER, P, exec, ${dms "processlist toggle"}"
              "SUPER, N, exec, ${dms "notifications toggle"}"
              "SUPER SHIFT, P, exec, ${dms "powermenu toggle"}"
              "SUPER, Period, exec, vicinae vicinae://extensions/vicinae/core/search-emojis"
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
              builtins.genList (i: [
                "SUPER, code:1${toString i}, workspace, ${toString (i + 1)}"
                "SUPER SHIFT, code:1${toString i}, movetoworkspace, ${toString (i + 1)}"
              ]) 9
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
            };

            decoration = {
              rounding = 0;
              blur = {
                enabled = true;
                size = 3;
                passes = 2;
                noise = 0.05;
                popups = true;
                popups_ignorealpha = 0.3;
              };
            };

            dwindle = {
              split_width_multiplier = 1.35;
              single_window_aspect_ratio = "16 9";
            };

            bezier = [
              "defout, 0.16, 1, 0.3, 1"
            ];

            animation = [
              "workspaces, 1, 3, defout, slidefadevert 15%"
              "windows, 1, 1.5, defout, popin"
              "fade, 0"
            ];

            exec-once = [
              "${lib.getExe pkgs.tailscale} systray"
              "${lib.getExe' pkgs.udiskie "udiskie"}"
              "${lib.getExe pkgs.wl-clip-persist} --clipboard regular"
            ];

            misc = {
              disable_hyprland_logo = true;
              disable_splash_rendering = true;
              vrr = 2;
              focus_on_activate = true;
              enable_swallow = true;
              swallow_regex = "^(kitty|ghostty|alacritty|foot)$";
              mouse_move_enables_dpms = true;
              key_press_enables_dpms = true;
              middle_click_paste = false;
            };

            layerrule = [
              "match:class ^(quickshell)$, no_anim on"
              "match:class ^(quickshell)$, blur on"
              "match:class ^(dms:.*)$, ignore_alpha 0.3"
            ];

            windowrule = [
              "match:class ^(org.quickshell)$, float on"
              "match:class ^(org.quickshell)$, center on"
              "match:class ^(org.quickshell)$, size (monitor_h*.70) (monitor_h*.80)"

              "match:class ^(org.pulseaudio.pavucontrol)$, float on"
              "match:class ^(org.pulseaudio.pavucontrol)$, center on"
              "match:class ^(org.pulseaudio.pavucontrol)$, size (monitor_w*.45) (monitor_h*.45)"

              "match:class org.freedesktop.impl.portal.desktop.gnome, float on"
              "match:class org.freedesktop.impl.portal.desktop.gnome, size (monitor_w*.60) (monitor_h*.65)"

              "match:class fsearch, float on"
              "match:class fsearch, center on"

              "match:class org.gnome.FileRoller, float on"
              "match:class org.gnome.FileRoller, center on"
              "match:class org.gnome.NautilusPreviewer, float on"
              "match:class org.gnome.NautilusPreviewer, center on"

              ''match:class ^jetbrains-.*$, match:float 1, match:title ^$|^\s$|^win\d+$, no_initial_focus on''

              "match:class Kodi, fullscreen on"

              "match:class steam, float on"
              ''match:class steam, match:title ^(?!\s*$).+, center on''
              "match:title Steam, float off" # floats everything but the main steam window

              "match:class xdg-desktop-portal-gtk, float on"
              "match:class xdg-desktop-portal-gtk, center on"
              "match:title ^(Open File)(.*)$, center on"
              "match:title ^(Open File)(.*)$, float on"
              "match:title ^(Select a File)(.*)$, center on"
              "match:title ^(Select a File)(.*)$, float on"
              "match:title ^(Open Folder)(.*)$, center on"
              "match:title ^(Open Folder)(.*)$, float on"
              "match:title ^(Save As)(.*)$, center on"
              "match:title ^(Save As)(.*)$, float on"
              "match:title ^(Library)(.*)$, center on"
              "match:title ^(Library)(.*)$, float on"
              "match:title ^(File Upload)(.*)$, center on"
              "match:title ^(File Upload)(.*)$, float on"
              "match:title ^(.*)(wants to save)$, center on"
              "match:title ^(.*)(wants to save)$, float on"
              "match:title ^(.*)(wants to open)$, center on"
              "match:title ^(.*)(wants to open)$, float on"
              "match:class crashreporter, float on"
              "match:class crashreporter, center on"

              "match:class ^(gsr-ui)$, float on"
              "match:class ^(gsr-ui)$, pin on"
              "match:class ^(gsr-ui)$, move 0 0"
            ];
          };
      };

      dconf = {
        enable = lib.mkForce true;
        settings."org/gnome/desktop/wm/preferences".button-layout = lib.mkForce "";
      };

      erebus.services.vicinae.enable = true;
    };
  };
}
