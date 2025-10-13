{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.erebus.system.boot.enable = lib.mkEnableOption "boot configuration";

  config = lib.mkIf config.erebus.system.boot.enable {
    boot = {
      kernelPackages = lib.mkDefault (
        if pkgs.stdenvNoCC.hostPlatform.isx86_64 then pkgs.linuxPackages_cachyos else pkgs.linuxPackages
      );

      loader = {
        limine.enable = true;
        efi.canTouchEfiVariables = true;
      };
    };
  };
}
