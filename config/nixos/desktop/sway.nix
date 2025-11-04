{
  pkgs,
  lib,
  config,
  self',
  ...
}:
{
  options.erebus.desktop.sway.enable = lib.mkEnableOption "Sway, configured with DMS.";

  config = lib.mkIf config.erebus.desktop.sway.enable {

    programs.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      package = pkgs.swayfx;
    };

    security.polkit.enable = lib.mkDefault true;
    services.gnome.gnome-keyring.enable = lib.mkDefault true;
    erebus.programs.dms.enable = true;

    home-manager.sharedModules = lib.singleton {
      wayland.windowManager.sway = {
        enable = true;
        package = null;
        wrapperFeatures.gtk = true; # Fixes common issues with GTK 3 apps
        config = rec {
          modifier = "Mod4"; # Super
          terminal = "ghostty";

          startup = map (cmd: { command = cmd; }) [
            "dms run"
            "${lib.getExe pkgs.autotiling} --splitratio 1.61"
            "${lib.getExe pkgs.dex} -a"
          ];

          keybindings =
            let
              exec = cmd: "exec ${cmd}";
              dms = cmd: "exec dms ipc call ${cmd}";
              ws = num: "workspace number ${toString num}";
              mws = num: "move container to workspace number ${toString num}; workspace number ${toString num}";
              pctl = cmd: "exec ${lib.getExe pkgs.playerctl} -p spotify ${cmd}";
              focus = cmd: "focus ${cmd}";
              move = cmd: "focus ${cmd}";
            in
            (lib.mapAttrs' (key: command: lib.nameValuePair "${modifier}+${key}" command) {

              "Return" = exec terminal;
              "Shift+s" = exec (lib.getExe self'.packages.skilshot);
              "space" = dms "spotlight toggle";
              "f" = exec "zen";
              "e" = exec "nautilus";

              "Shift+q" = "kill";
              "Shift+f" = "fullscreen toggle";
              "Shift+space" = "floating toggle";

              "p" = dms "processlist toggle";
              "n" = dms "notifications toggle";
              "Shift+p" = dms "powermenu toggle";

              "Left" = focus "left";
              "Right" = focus "right";
              "Up" = focus "up";
              "Down" = focus "down";

              "Shift+Left" = move "left";
              "Shift+Right" = move "right";
              "Shift+Up" = move "up";
              "Shift+Down" = move "down";

              "1" = ws 1;
              "2" = ws 2;
              "3" = ws 3;
              "4" = ws 4;
              "5" = ws 5;
              "6" = ws 6;
              "7" = ws 7;
              "8" = ws 8;
              "9" = ws 9;

              "Shift+1" = mws 1;
              "Shift+2" = mws 2;
              "Shift+3" = mws 3;
              "Shift+4" = mws 4;
              "Shift+5" = mws 5;
              "Shift+6" = mws 6;
              "Shift+7" = mws 7;
              "Shift+8" = mws 8;
              "Shift+9" = mws 9;
            })
            // {
              "XF86AudioRaiseVolume" = dms "audio increment 2";
              "XF86AudioLowerVolume" = dms "audio decrement 2";
              "XF86AudioNext" = dms "mpris next";
              "XF86AudioPrev" = dms "mpris previous";
              "XF86AudioPlay" = dms "mpris playPause";
              "XF86Launch9" = pctl "volume 0.02+";
              "XF86Launch8" = pctl "volume 0.02-";
            };

          gaps = {
            inner = 6;
            outer = 2;
          };

          input."*" = {
            xkb_layout = "gb";
            accel_profile = "flat";
            pointer_accel = "0.65";
          };

          output.DP-3 = {
            resolution = "3440x1440@165Hz";
            position = "0 0";
          };

          bars = [ ]; # we are using dms for our bar/shell.,

          window.titlebar = false;
        };
        extraConfig = ''
          for_window [class="Godot"] floating enable
          corner_radius 8
          focus_on_window_activation focus
        '';
      };

      dconf = {
        enable = lib.mkForce true;
        settings."org/gnome/desktop/wm/preferences".button-layout = lib.mkForce "";
      };
    };
  };
}
