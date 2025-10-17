{
  lib,
  config,
  pkgs,
  self',
  ...
}:
{
  options.erebus.profiles.gaming.enable =
    lib.mkEnableOption "gaming related *stuff*. This includes VR.";

  config = lib.mkIf config.erebus.profiles.gaming.enable {
    erebus = {
      programs = {
        gamemode.enable = true;
        gsr.enable = true;
        steam.enable = true;
        wivrn.enable = true;
      };

      services = {
        sunshine.enable = true;
      };
    };

    environment.systemPackages = with pkgs; [
      bs-manager
      dolphin-emu
      lutris
      ludusavi
      osu-lazer-bin
      r2modman
      ryubing # switch emu
      self'.packages.wheelwizard
      lsfg-vk
      lsfg-vk-ui # frame gen
      vrcx
    ];

    home-manager.sharedModules = lib.singleton {
      erebus.programs.prismlauncher.enable = true;
      programs.mangohud.enable = true;
    };
  };
}
