{
  config,
  lib,
  pkgs,
  ...
}: {
  options.erebus.system.boot.enable = lib.mkEnableOption "boot configuration";

  config = lib.mkIf config.erebus.system.boot.enable {
    boot = {
      kernelPackages = lib.mkDefault pkgs.linuxPackages_cachyos;

      loader = {
        limine.enable = true;
        efi.canTouchEfiVariables = true;
      };
    };
  };
}
