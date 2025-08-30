{
  config,
  pkgs,
  lib,
  inputs',
  ...
}:
{
  options.erebus.programs.wivrn.enable = lib.mkEnableOption "WiVRn";

  config = lib.mkIf config.erebus.programs.wivrn.enable {
    services.wivrn = {
      enable = true;
      openFirewall = true;
      defaultRuntime = true;
    };

    environment.systemPackages = with pkgs; [
      android-tools
      wlx-overlay-s
    ];

    home-manager.sharedModules = lib.singleton (userAttrs: {
      # This assumes a WiVRn configuration
      xdg.configFile."openxr/1/active_runtime.json".source =
        "${config.services.wivrn.package}/share/openxr/1/openxr_wivrn.json";

      xdg.configFile."openvr/openvrpaths.vrpath".text = ''
        {
          "config" :
          [
            "${userAttrs.config.xdg.dataHome}/Steam/config"
          ],
          "external_drivers" : null,
          "jsonid" : "vrpathreg",
          "log" :
          [
            "${userAttrs.config.xdg.dataHome}/Steam/logs"
          ],
          "runtime" :
          [
            "${pkgs.opencomposite}/lib/opencomposite"
          ],
          "version" : 1
        }
      '';

      xdg.configFile."wlxoverlay/wayvr.yaml".source = (pkgs.formats.yaml { }).generate "wayvr.yaml" {
        version = 1;
        run_compositor_at_start = false;
        auto_hide = true;
        auto_hide_delay = 750;

        dashboard = {
          exec = lib.getExe inputs'.nixpkgs-xr.packages.wayvr-dashboard;
          blit_method = "software";
          env = [
            "GDK_BACKEND=wayland"
            "WEBKIT_DISABLE_DMABUF_RENDERER=1"
            "WEBKIT_DISABLE_COMPOSITING_MODE=1"
          ];
        };
      };
    });
  };
}
