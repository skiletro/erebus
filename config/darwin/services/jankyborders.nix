{ config, lib, ... }:
{
  options.erebus.services.jankyborders.enable = lib.mkEnableOption "Jankyborders";

  config = lib.mkIf config.erebus.services.jankyborders.enable {
    home-manager.sharedModules = lib.singleton {
      services.jankyborders = {
        enable = true;
        settings = {
          style = "round";
          width = "4.0";
          hidpi = true;
          blacklist = builtins.concatStringsSep "," [
            "Steam"
            "FaceTime"
            "Screen Sharing"
          ];
          active_color = lib.mkDefault "0xffffffff"; # so that stylix can override
          inactive_color = lib.mkDefault "0x00000000"; # so that stylix can override
        };
      };
    };
  };
}
