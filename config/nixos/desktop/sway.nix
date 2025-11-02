{
  pkgs,
  lib,
  config,
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
          menu = "dms ipc call spotlight toggle";

          startup = map (cmd: { command = cmd; }) [
            "dms run"
            "${lib.getExe pkgs.autotiling} --splitratio 1.61"
            "${lib.getExe pkgs.dex} -a"
          ];

          keybindings =
            (lib.mapAttrs' (key: command: lib.nameValuePair "${modifier}+${key}" command) {
              "Return" = "exec ${terminal}";
              "Shift+s" = "exec ${lib.getExe pkgs.sway-contrib.grimshot} copy area";
              "space" = "exec ${menu}";
              "f" = "exec zen";
              "e" = "exec nautilus";

              "Shift+q" = "kill";
              "Shift+f" = "fullscreen toggle";

              "Left" = "focus left";
              "Right" = "focus right";
              "Up" = "focus up";
              "Down" = "focus down";

              "Shift+Left" = "move left";
              "Shift+Right" = "move right";
              "Shift+Up" = "move up";
              "Shift+Down" = "move down";

              "1" = "workspace number 1";
              "2" = "workspace number 2";
              "3" = "workspace number 3";
              "4" = "workspace number 4";
              "5" = "workspace number 5";
              "6" = "workspace number 6";
              "7" = "workspace number 7";
              "8" = "workspace number 8";
              "9" = "workspace number 9";

              "Shift+1" = "move container to workspace number 1; workspace number 1";
              "Shift+2" = "move container to workspace number 2; workspace number 2";
              "Shift+3" = "move container to workspace number 3; workspace number 3";
              "Shift+4" = "move container to workspace number 4; workspace number 4";
              "Shift+5" = "move container to workspace number 5; workspace number 5";
              "Shift+6" = "move container to workspace number 6; workspace number 6";
              "Shift+7" = "move container to workspace number 7; workspace number 7";
              "Shift+8" = "move container to workspace number 8; workspace number 8";
              "Shift+9" = "move container to workspace number 9; workspace number 9";

              "Shift+space" = "floating toggle";

              # "Alt_L+s" = "layout stacking";
              # "Alt_L+w" = "layout tabbed";
              # "Alt_L+e" = "layout toggle split";
            })
            // {
              "XF86AudioRaiseVolume" = "exec dms ipc call audio increment 2";
              "XF86AudioLowerVolume" = "exec dms ipc call audio decrement 2";
              "XF86AudioNext" = "exec ${lib.getExe pkgs.playerctl} next";
              "XF86AudioPrev" = "exec ${lib.getExe pkgs.playerctl} previous";
              "XF86AudioPlay" = "exec ${lib.getExe pkgs.playerctl} play-pause";
              "XF86Launch9" = "exec ${lib.getExe pkgs.playerctl} -p spotify volume 0.02+";
              "XF86Launch8" = "exec ${lib.getExe pkgs.playerctl} -p spotify volume 0.02-";
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
        '';
      };

      dconf = {
        enable = lib.mkForce true;
        settings."org/gnome/desktop/wm/preferences".button-layout = lib.mkForce "";
      };
    };
  };
}
