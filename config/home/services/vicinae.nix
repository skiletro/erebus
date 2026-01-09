{ config, lib, ... }:
{
  options.erebus.services.vicinae.enable = lib.mkEnableOption "Vicinae";

  config = lib.mkIf config.erebus.services.vicinae.enable {
    programs.vicinae = {
      enable = true;
      systemd.enable = true;
    };
  };
}
