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
    services.wivrn =
      let
        inherit (inputs'.nixpkgs-xr.packages) wivrn xrizer opencomposite;
      in
      {
        enable = true;
        package = wivrn.override {
          ovrCompatSearchPaths = "${xrizer}/lib/xrizer:${opencomposite}/lib/opencomposite";
        };
        openFirewall = true;
        defaultRuntime = true;
        steam.importOXRRuntimes = true;
        highPriority = true;
      };

    environment.systemPackages = with pkgs; [
      android-tools
      wayvr
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
    });
  };
}
